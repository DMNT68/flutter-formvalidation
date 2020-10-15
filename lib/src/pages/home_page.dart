import 'dart:async';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';

import 'package:formvalidation/src/models/producto_model.dart';

class HomePage extends StatefulWidget {
    
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargandoProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {

    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        if ( snapshot.hasData ) {
          
          final productos = snapshot.data;
          return RefreshIndicator(
            onRefresh: () => refresh(productosBloc),
            child: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context,i) => _crearItem(context, productosBloc, productos[i])
            ), 
          );
         
        } else {
          
          return Center(
            child: CircularProgressIndicator(),
          );

        }
      },
    );
  }

  Future<Null> refresh(ProductosBloc productosBloc)async{
    
    final duration = new Duration(seconds: 2);
    new Timer(duration, (){
      productosBloc.cargandoProductos();
    });
    
    return Future.delayed(duration);
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc ,ProductoModel producto) {

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red
      ),
      onDismissed: (direccion)=> productosBloc.borrarProducto(producto.id),
      child: Card(
        child: Column(
          children: [
            producto.fotoUrl == null 
            ? Image(image: AssetImage('assets/no-image.png'),)
            : FadeInImage(
                image: NetworkImage(producto.fotoUrl),
                placeholder: AssetImage('assets/jar-loading.gif'),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover
              ),
              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto).then((value) { setState(() { }); }),
              ),
          ],
        ),
      )
    );

    

  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'producto').then((value) { setState(() { });}),
      backgroundColor: Colors.deepPurple,
    );
  }
}