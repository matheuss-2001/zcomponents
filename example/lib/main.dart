import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:z_components/components/z-collection-item.dart';
import 'package:z_components/components/z-float-button.dart';
import 'package:z_components/components/z-item-tile.dart';
import 'package:z_components/components/z-check-cpf.dart';
import 'package:z_components/components/z-pin-senha.dart';
import 'package:z_components/components/z_tabbar.dart';
import 'package:z_components/components/z-baseline.dart';
import 'package:z_components/components/z_navigationbar.dart';
import 'package:z_components/components/z-collection.dart';
import 'package:z_components/components/z-header.dart';
import 'package:z_components/components/z-header-expansion.dart';
import 'package:z_components/components/z-hora-padrao.dart';
import 'package:z_components/components/zp-grafico.dart';
import 'package:z_components/components/z-expansion-tile.dart';
import 'package:z_components/components/z-hora-um-campo.dart';
import 'package:z_components/components/z-instrucao-batida.dart';
import 'package:flutter/cupertino.dart';
import 'package:z_components/config/z-tipo-header.dart';
import 'package:z_components/config/z-tipo-senha.dart';
import 'package:z_components/config/z-tipos-baseline.dart';
import 'package:z_components/components/z-expendable-item-tile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: ComponentExemploClasse()
        ),
        bottomNavigationBar: ZtabBar(
          backgroundColor: Colors.teal,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              title: Text('Business'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text('School'),
            ),
          ],
          onTap: (index) => this.index = index,
          currentIndex: 0,
          iconSize: 16,
          inactiveColor: Colors.red,
          activeColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black45,
          // currentIndex: _selectedIndex,
        ),
      ),
    );
  }
}
class ComponentExemploClasse extends StatefulWidget {

  @override
  _ComponentExemploClasseState createState() => _ComponentExemploClasseState();
}
class _ComponentExemploClasseState extends State<ComponentExemploClasse> {
  bool value = false;

  var _key = new GlobalKey<ZCollectioState>();
  var _key2 = new GlobalKey<ZCollectioState>();


  Key _expansions;
  Key _expansionTile;
  bool _collapsed = true;
  String _value = "open";
  String _value2 = "close";

  @override
  void initState() {
    super.initState();
    _expansionTile = PageStorageKey<String>(_value);
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: ZFloatButton(
          onPressed: () {},
        ),
        appBar: ZNavigationBar(
          leading: new Icon(Icons.print),
          trailing: new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                new InformacaoBatida(
                  bottomChild: new Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 5),
                      child: new ButtonTheme(
                        minWidth: 145,
                        child: new RaisedButton(
                            color: Color(0xff2bbab4),
                            child: new Text("ENTENDI", style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))
                        ),
                      )
                  ),
                )),
              );
            },
            child: new Container(
              child: new Icon(
                Icons.info,
                color: Colors.white,
                size: 19.0,
              ),

            ),
          ),
        ),
        body: new ListView(
          children: <Widget>[
            new Column(children: <Widget>[
              new ZHeader(
                titulo: "TESTE",
              ),
              new ZHeaderExpansion(
                titulo: "Teste Expanded",
                value: _value,
                key: _expansionTile,
                collapsed: _collapsed,
              ),
              new ZCollection(
                key: _key,
                titulo: "Cargos",
                lista: [
                  "Vigilante Condutor de Animais",
                  "Analista de Departamento Pessoal",
                  "Assistente de Tecnico de Seguranca do Trabalho",
                  "Coordenador de Seguranca do Trabalho",
                  "Encarregado de Manutencao de Areas Verdes",
                  "Assistente de TI",
                  "Auxiliar Mecanico de Refrigeracao",
                  "Coordenador de Departamento Pessoal",
                  "Coordenador de Relacionamento com Cliente",
                  "Diretor de Desenvolvimento de Negocios",
                  "Gerente de Desemvolvimento de Ngocios",
                  "Gerente de Relacionamnto com Cliente",
                  "Lider de Monitoramento de Sistmemas Eletronicos",
                  "Meio Oficial de Manutencao Eletrica",
                  "Secretaria - Analista",
                  "Secretaria de Analista"
                ]
                    .map(
                        (x) =>
                    new ZCollectionItem(chave: x, titulo: x, valor: x))
                    .toList(),
                onChange: (item) {
                  if (_key.currentState.itemSelecionado != null)
                    print(_key.currentState.itemSelecionado.valor);
                  else {
                    print("Nenhum item");
                  }
                },
              ),
              new ZBaseLine(
                zTipos: ZTipoBaseline.isNomeCompleto,
                context: context,
              ),
              new ZBaseLine(
                zTipos: ZTipoBaseline.isCPF,
                context: context,
              ),
              new ZBaseLine(
                zTipos: ZTipoBaseline.isCelular,
                context: context,
              ),
              new ZBaseLine(
                zTipos: ZTipoBaseline.isEmail,
                context: context,
              ),
              new ZBaseLine(
                zTipos: ZTipoBaseline.isDataNascimento,
                context: context,
              ),
              new Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: new ZExpansion(
                  childTitle: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        padding: const EdgeInsets.all(10),
                        child: new Text("Titulo"),
                      ),
                    ],
                  ),
                ),
              ),
              new ZPGrafico(
                key: _expansionTile,
                tituloCenterCircle: "ESCOLA",
                titulo: "Ponto Hoje",
                tituloItem1: "Sapatos",
                tituloItem2: "Escovas",
                tituloItem3: "Disco Vinil",
                valueItem1: 10.0,
                valueItem2: 30.0,
                valueItem3: 10.0,
                onTapItem1: () {
                  print("Tap Item 1");
                },
                onTapItem2: () {
                  print("Tap Item 2");
                },
                onTapItem3: () {
                  print("Tap Item 3");
                },
              ),
              new ZHora(),
              new ZHoraUmCampo(
                titulo: "Horinha",
              ),
              new ZPinSenha(
                context: context,
                numeroQuadrados: 4,
                zTipos: ZTipoSenha.isSenha,
              ),
              new ZPinSenha(
                context: context,
                numeroQuadrados: 4,
                zTipos: ZTipoSenha.isRepetirSenha,
              ),
              new ZCheckCPF(),
              new ZItemTile(
                textoTitulo:
                "Bento Raimundo da Mata ag rg G wrgWRAER HGAER H tshssth ",
                textoDois: "Sede - Fernando ltda.",
                textoTres: "Sede - Fernando ltda.",
                textoQuatro: "5x2",
                textoCinco: "(seg-sex)",
                textoSeis: "08:00-17:48",
                textoSete: "1:00",
                textoCodigo: "012345",
                status: true,
                funcao: () {},
              ),
              Container(
                height: 30.0,
              ),
              new ZItemTile(),
              Container(
                height: 30.0,
              ),
              new ZExpendableItemTile(
                textoTitulo:
                "Bento Raimundo da Mata ag rg G wrgWRAER HGAER H tshssth ",
                textoDois: "Sede - Fernando ltda.",
                textoTres: "Sede - Fernando ltda.",
                textoQuatro: "5x2",
                textoCinco: "(seg-sex)",
                textoSeis: "08:00-17:48",
                textoSete: "1:00",
                textoCodigo: "012345",
                status: true,
                funcao: () {},
                iconeUm: new Icon(Icons.phone, color: const Color(0xff2BB9B4)),
                textoIconeUm: "(11)99867-9893",
                iconeDois: new Icon(Icons.map, color: const Color(0xff2BB9B4)),
                textoIconeDois: "Casa - trabalho",
                iconeTres:
                new Icon(Icons.description, color: const Color(0xff2BB9B4)),
                textoIconeTres: "Espelho de Ponto",
                iconeQuatro:
                new Icon(Icons.warning, color: const Color(0xff2BB9B4)),
                textoIconeQuatro: "Ocorrencia",
              ),
              Container(
                height: 30.0,
              ),
              ZExpendableItemTile(),
              Container(
                height: 30.0,
              ),
              new Container(
                height: 80.0,
              )
            ]),
          ],
        ),
      );
    }
}
class AppSwitch with ChangeNotifier {
  AppSwitch();

  bool _value = false;
  String _text = "";

  set value(bool text) {
    _value = text;
    notifyListeners();
  }

  bool get value => _value;

  set text(String text) {
    _text = text;
    notifyListeners();
  }

  String get text => _text;
}
