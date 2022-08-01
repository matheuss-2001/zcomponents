import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:z_components/components/filtro/filter-expression.dart';
import 'package:z_components/components/filtro/filtro-campo.dart';
import 'package:z_components/components/z-collection/z-collection-item.dart';
import 'package:z_components/components/z-collection/z-collection-list.dart';

class ZCollection extends StatefulWidget {
  final String titulo;
  final List<ZCollectionItem> lista;
  final ThemeData themeData;
  final ValueChanged<ZCollectionItem> onChange;
  final String valorPadrao;
  final Color colorStyle;
  final int skip;
  final int take;
  final bool campoObrigatorio;
  bool editado;
  final bool bloquearCampo;
  final FiltroCampo filtroPrincipal;
  final Function(List<FilterExpression>) onFilter;
  Function(List<FilterExpression>, List<ZCollectionItem>) onScroll;
  Function onClear;

  ZCollection(
      {Key key,
      @required this.titulo,
      @required this.lista,
      @required this.themeData,
      this.onChange,
      this.valorPadrao,
      this.colorStyle: const Color(0xff2bbab4),
      this.skip: 0,
      this.take: 0,
      this.campoObrigatorio = false,
      this.filtroPrincipal,
      this.onFilter,
      this.bloquearCampo = false,
      this.onScroll,
      this.editado = false,
      this.onClear})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ZCollectionState();
}

class ZCollectionState extends State<ZCollection> {
  ZCollectionItem _itemSelecionado = new ZCollectionItem();
  String _anterior = "Selecione";
  GlobalKey<ZCollectionListState> keyLista =
      new GlobalKey<ZCollectionListState>();

  ZCollectionItem get itemSelecionado => _itemSelecionado;

  @override
  void initState() {
    buscarValorPadrao(widget.lista);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Column(
        children: <Widget>[
          new Container(
            height: 39,
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16.0, right: 14),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _returnRequiredField(),
                new Flexible(
                    flex: 65,
                    fit: FlexFit.tight,
                    child: new Text(
                      retornarTexto(),
                      style: _retornaCorTexto(),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )),
                new Flexible(
                  flex: 10,
                  fit: FlexFit.tight,
                  child: retornarIcone(),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: _irParaSelecaoDeItemHorizontal,
    );
  }

  String retornarTexto() {
    if (widget.editado) {
      if (_itemSelecionado?.valor == null && _anterior == "Selecione") {
        return _anterior;
      } else {
        return _itemSelecionado?.valor + " (Editado)";
      }
    } else {
      if (_itemSelecionado?.valor == null && _anterior == "Selecione") {
        return _anterior;
      } else {
        return _itemSelecionado?.valor;
      }
    }
  }

  Color _retornaCorIcon() {
    if (widget.bloquearCampo) {
      return Colors.grey;
    } else if (_itemSelecionado?.valor == null && _anterior == "Selecione") {
      return widget.themeData.primaryColor;
    } else {
      return Colors.black;
    }
  }

  Widget retornarIcone() {
    if (_itemSelecionado?.valor == null && _anterior == "Selecione") {
      return new Icon(Icons.keyboard_arrow_right, color: _retornaCorIcon());
    } else {
      return new IconButton(
          onPressed: () {
            if (widget.bloquearCampo) {
              return null;
            } else {
              setState(() {
                _itemSelecionado = null;
                if (widget.onClear != null) widget.onClear();
              });
            }
          },
          icon: new Icon(Icons.clear, color: _retornaCorIcon()));
    }
  }

  void atualizarLista(List<ZCollectionItem> lista) {
    keyLista.currentState.atualizarLista(lista);
  }

  void buscarValorPadrao(List<ZCollectionItem> lista) {
    if (lista != null && lista.length > 0) {
      if (widget.valorPadrao != null) {
        var vP =
            lista.where((lista) => lista.chave == widget.valorPadrao).first;
        if (vP != null) {
          setState(() {
            _itemSelecionado = vP;
          });
        }
      }
    }
  }

  void setarvalor() {
    if (_itemSelecionado?.valor != null) {
      setState(() {
        _anterior = _itemSelecionado?.valor;
      });
    }
  }

  void _irParaSelecaoDeItemHorizontal() async {
    if (!widget.bloquearCampo) {
      _itemSelecionado = await Navigator.push<ZCollectionItem>(
          context,
          new PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation animation,
                Animation secondaryAnimation) {
              return new ZCollectionList(
                key: keyLista,
                lista: widget.lista,
                titulo: widget.titulo,
                ultimoValor: _itemSelecionado,
                color: widget.colorStyle,
                skip: widget.skip,
                take: widget.take,
                theme: widget.themeData,
                onChange: widget.onFilter,
                filtroPrincipal: widget.filtroPrincipal,
                onScroll: widget.onScroll,
              );
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return new SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: new SlideTransition(
                  position: new Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(1.0, 0.0),
                  ).animate(secondaryAnimation),
                  child: child,
                ),
              );
            },
          ));
      if (widget.onChange != null) widget.onChange(_itemSelecionado);

      setState(() {});
    }
  }

  Widget _returnRequiredField() {
    if (widget.campoObrigatorio) {
      return new Flexible(
        flex: 45,
        fit: FlexFit.tight,
        child: new RichText(
          maxLines: 2,
          text: new TextSpan(
            children: <TextSpan>[
              new TextSpan(
                text: "${widget.titulo}",
                style: widget.themeData.textTheme.bodyText1
                    .copyWith(color: Color(0xff999999)),
              ),
              new TextSpan(text: "*", style: TextStyle(color: Colors.redAccent))
            ],
          ),
        ),
      );
    } else {
      return new Flexible(
        flex: 45,
        fit: FlexFit.tight,
        child: new RichText(
          maxLines: 2,
          text: TextSpan(
            children: <TextSpan>[
              new TextSpan(
                text: "${widget.titulo}",
                style: widget.themeData.textTheme.bodyText1
                    .copyWith(color: const Color(0xff999999)),
              ),
            ],
          ),
        ),
      );
    }
  }

  TextStyle _retornaCorTexto() {
    if (widget.bloquearCampo &&
        _itemSelecionado?.valor == null &&
        _anterior == "Selecione") {
      return widget.themeData.textTheme.bodyText1.copyWith(color: Colors.grey);
    } else if (widget.bloquearCampo) {
      return widget.themeData.textTheme.bodyText1.copyWith(color: Colors.grey);
    } else if (_itemSelecionado?.valor == null && _anterior == "Selecione") {
      return widget.themeData.textTheme.bodyText1.copyWith(color: Colors.black);
    } else {
      return widget.themeData.textTheme.bodyText1.copyWith(color: Colors.black);
    }
  }
}
