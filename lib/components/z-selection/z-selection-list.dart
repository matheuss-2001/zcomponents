import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:z_components/components/filtro/filter-expression.dart';
import 'package:z_components/components/filtro/filtro-campo.dart';
import 'package:z_components/components/utils/icone-voltar.dart';
import 'package:z_components/components/z-selection/dialog-itens-selecionados.dart';
import 'package:z_components/components/z-selection/z-selection-item.dart';
import 'package:z_components/components/z-tile.dart';

import '../../config/z-dialog.dart';
import '../../styles/main-style.dart';
import '../z-alert-dialog.dart';

class ZSelectionList extends StatefulWidget {
  GlobalKey keyListaItens = new GlobalKey();
  GlobalKey key;
  List<ZSelectionItem> lista;
  final ThemeData theme;
  final String titulo;
  final color;
  final FiltroCampo filtroPrincipal;
  int skip;
  int take;
  Function(List<FilterExpression>) onChange;
  Function(List<FilterExpression>, List<ZSelectionItem>) onScroll;
  Function() onAdd;
  String textoOnAdd;
  List<ZSelectionItem> listaSelecao;

  ZSelectionList(
      {this.lista,
      this.key,
      this.theme,
      this.titulo: "",
      this.color,
      this.skip: 0,
      this.take: 0,
      this.onChange,
      this.filtroPrincipal,
      this.onScroll,
      this.onAdd,
      this.textoOnAdd,
      this.listaSelecao})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ZSelectionListState();
}

class ZSelectionListState extends State<ZSelectionList> {
  List<ZSelectionItem> _listaFiltro;
  ScrollController scrollController;
  GlobalKey keyLista = new GlobalKey();
  String textoBusca = "";

  @override
  void initState() {
    _listaFiltro = <ZSelectionItem>[];
    scrollController = new ScrollController();
    scrollController.addListener(_scrollListener);
    montarRespostas();
    _initList();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: widget.theme.backgroundColor,
      appBar: new AppBar(
        backgroundColor: widget.color,
        leading: IconeVoltar(
          context: context,
        ),
        centerTitle: true,
        title: new Container(
          child: new Text(
            widget.titulo.toUpperCase(),
            style: new TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: new Column(
        children: <Widget>[
          _buildFiltro(),
          _montarExibicaoContadorSelecionados(),
          new Expanded(
              child: new Container(
            key: widget.keyListaItens,
            margin: EdgeInsets.only(top: 16.0),
            child: _buildLista(),
          )),
          montarAddMais(),
          _exibirBotao()
        ],
      ),
    );
  }

  void montarRespostas() {
    for (int i = 0; i < widget.lista.length; i++) {
      widget.lista[i].selecionado = false;
      for (int j = 0; j < widget.listaSelecao.length; j++) {
        if (widget.listaSelecao[j].chave == widget.lista[i].chave) {
          widget.lista[i].selecionado = true;
          widget.lista[i].obrigatorio = widget.listaSelecao[j].obrigatorio;
        }
      }
    }
  }

  Widget montarAddMais() {
    if (widget.textoOnAdd == null || widget.textoOnAdd.isEmpty) {
      return new Container();
    } else {
      return new Column(
        children: [
          new Divider(
            height: 1,
          ),
          new ZTile(
            onTap: () {
              widget.onAdd();
            },
            leading: new Text(widget.textoOnAdd),
            trailing: new Icon(Icons.add, color: widget.theme.primaryColor)
          ),
          new Divider(
            height: 1,
          ),
        ],
      );
    }
  }

  Widget _buildFiltro() {
    return new Material(
        elevation: 5,
        child: new Row(
          children: <Widget>[
            new Expanded(
              flex: 85,
              child: new Container(
                margin: const EdgeInsets.only(bottom: 6, top: 6.0),
                child: new Container(
                  height: 36,
                  margin: EdgeInsets.only(left: 16, right: 2),
                  decoration: BoxDecoration(
                      color: Color(0xfff0f0f0),
                      borderRadius: BorderRadius.all(Radius.circular(9.0))),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: new Icon(
                            Icons.search,
                            color: Color(0xff999999),
                          )),
                      new Expanded(
                          child: new CupertinoTextField(
                        placeholderStyle: new TextStyle(
                            color: Color(0xff999999), fontSize: 17),
                        placeholder: "Busca",
                        decoration:
                            new BoxDecoration(color: Colors.transparent),
                        onChanged: (text) {
                          if (text.length >= 3 || text.length == 0) {
                            if (widget.onChange != null) {
                              textoBusca = text;
                              widget.onChange([
                                new FilterExpression(
                                    propertyName: widget.filtroPrincipal.key,
                                    operatorBetween: "AndAlso",
                                    operator: "Contains",
                                    value: text)
                              ]);
                            } else {
                              text = text.toLowerCase();
                              keyLista = new GlobalKey();
                              setState(() {
                                if (text.length > 0)
                                  _listaFiltro = widget.lista
                                      .where((x) =>
                                          x.valor.toLowerCase().contains(text))
                                      .toList();
                                else
                                  _listaFiltro = widget.lista;
                              });
                            }
                            widget.keyListaItens = new GlobalKey();
                          }
                        },
                      )),
                    ],
                  ),
                ),
              ),
            ),
            new Expanded(
                flex: 15,
                child: new IconButton(
                    icon: new Icon(
                      Icons.filter_list,
                      color: widget.color,
                    ),
                    onPressed: () {}))
          ],
        ));
  }

  Widget _buildLista() {
    if (_listaFiltro.isEmpty) {
      return new Column(
        children: [
          new Container(
            padding: const EdgeInsets.all(16.0),
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            margin: const EdgeInsets.only(top: 8),
            child: new Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(2.0),
              decoration: new BoxDecoration(
                  border: new Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: new BorderRadius.all(Radius.circular(16.0))),
              child: new Text(
                '${'Para encontrar os ' + '${widget.titulo.toLowerCase()}' + ' desejados, utilize o campo de busca acima.'}',
                maxLines: 4,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Flexible(
            child: new Container(
              height: MediaQuery.of(context).size.height * 0.35,
              padding: const EdgeInsets.only(top: 16),
              child: new SvgPicture.asset('assets/img_background.svg'),
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
        key: keyLista,
        itemCount: _listaFiltro.length,
        controller: scrollController,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var item = _listaFiltro[index];
          return new Column(
            children: [
              new Container(
                alignment: Alignment.topCenter,
                color: Colors.white,
                child: new ZTile(
                  onTap: () {
                    if (!item.obrigatorio) {
                      setState(() {
                        item.selecionado = !item.selecionado;

                        if (item.selecionado) {
                          widget.listaSelecao.add(item);
                        } else {
                          for (int i = 0; i < widget.listaSelecao.length; i++) {
                            if (widget.listaSelecao[i].chave == item.chave) {
                              widget.listaSelecao.removeAt(i);
                              break;
                            }
                          }
                        }
                      });
                    }
                  },
                  leading: new Row(
                    children: [
                      new Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: new Text(
                          "${item.titulo ?? item.valor}",
                          style: widget.theme.textTheme.bodyText1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  trailing: new Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value: item.selecionado,
                      onChanged: (bool) {
                        if (!item.obrigatorio) {
                          setState(() {
                            item.selecionado = bool;
                            if (item.selecionado) {
                              widget.listaSelecao.add(item);
                            } else {
                              for (int i = 0;
                                  i < widget.listaSelecao.length;
                                  i++) {
                                if (widget.listaSelecao[i].chave ==
                                    item.chave) {
                                  widget.listaSelecao.removeAt(i);
                                  break;
                                }
                              }
                            }
                          });
                        }
                      }),
                ),
              ),
              new Divider(
                height: 2,
                color: widget.theme.backgroundColor,
              ),
            ],
          );
        },
      );
    }
  }

  Widget _montarExibicaoContadorSelecionados() {
    String contador = widget.listaSelecao.length.toString();
    if (contador == "0") {
      return new Container();
    } else {
      return GestureDetector(
        onTap: () async {
          await dialogItensSelecionados();
          if (mounted) setState(() {});
        },
        child: new Container(
          color: Colors.white,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Container(
                padding: EdgeInsets.only(left: 16),
                child: new Text("${widget.titulo} selecionados"),
              ),
              new Container(
                margin: EdgeInsets.only(right: 16.0),
                child: new Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(6),
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    child: new Text(
                      contador.padLeft(2, "0"),
                    )),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget _exibirBotao() {
    return new Material(
      elevation: 4.0,
      child: new Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height / 8,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            new RaisedButton(
              onPressed: () {
                _selecionarItem(_listaFiltro);
              },
              child: new Container(
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new Container(
                      padding: const EdgeInsets.only(right: 40, left: 40),
                      child: new Text(
                        "SALVAR",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Color(0xFFFFFFFF)),
                      ),
                    )
                  ],
                ),
              ),
              color: Theme.of(context).primaryColor,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.only(left: 10, right: 10),
            )
          ],
        ),
      ),
    );
  }

  void _selecionarItem(List<ZSelectionItem> item) {
    Navigator.of(context).pop([item, widget.listaSelecao]);
  }

  Future<void> _initList() {
    if (widget.take == 0) {
      setState(() {
        _listaFiltro = widget.lista;
      });
    } else {
      var listaSkipTake =
          widget.lista.skip(widget.skip).take(widget.take).toList();

      if (listaSkipTake != null && listaSkipTake.length > 0) {
        setState(() {
          _listaFiltro.addAll(listaSkipTake);
          widget.skip += widget.take;
        });
      }
    }
  }

  Future<void> _scrollListener() async {
    if (widget.take > 0) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        var listaSkipTake =
            widget.lista.skip(widget.skip).take(widget.take).toList();
        if (listaSkipTake != null && listaSkipTake.length > 0) {
          setState(() {
            _listaFiltro.addAll(listaSkipTake);
            widget.skip += widget.take;
          });
        }
      }
    }
    if (widget.onScroll != null) {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        widget.onScroll([
          new FilterExpression(
              propertyName: widget.filtroPrincipal.key,
              operatorBetween: "AndAlso"
                  "",
              operator: "Contains",
              value: textoBusca)
        ], _listaFiltro);
      }
    }
  }

  void atualizarLista(List<ZSelectionItem> lista) {
    _listaFiltro = lista;
    montarRespostas();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> dialogItensSelecionados() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DialogItensSelecionados(
                  listaSelecao: widget.listaSelecao,
                  theme: widget.theme,
                  keyListagemSelecao: widget.key,
                )));
  }

  void atualizarListas(List<ZSelectionItem> listaAtualizado) {
    widget.listaSelecao = listaAtualizado;

    for (int i = 0; i < _listaFiltro.length; i++) {
      _listaFiltro[i].selecionado = false;
      for (int j = 0; j < widget.listaSelecao.length; j++) {
        if (_listaFiltro[i].chave == widget.listaSelecao[j].chave) {
          _listaFiltro[i].selecionado = true;
        }
      }
    }
  }
}
