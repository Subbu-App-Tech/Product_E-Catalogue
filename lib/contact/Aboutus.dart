import 'package:flutter/material.dart';
import 'package:productcatalogue/export.dart';

class AboutUs extends StatelessWidget {
  static const routeName = '/AboutUs';
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget textformate(String text) {
      return Container(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Text(
          text,
          textAlign: TextAlign.left,
        ),
      );
    }

    Widget buttonstyle(String text) {
      return Container(
        color: Colors.blue,
        padding: EdgeInsets.all(8),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.left,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('About App'),
      ),
      body: Card(
        elevation: 12,
        child: Container(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                Card(
                  elevation: 7,
                  child: ExpansionTile(
                    title: Text('About Product Catalogue'),
                    children: [
                      textformate(''' 
  Product Catalouge is built to help you manage and market your products easily. 
  This application provides you functionalities to add, search, & create Wonderfull Product Catalogue for your products.
  This will help to keep your products handy.
                    ''')
                    ],
                  ),
                ),
                Card(
                  elevation: 7,
                  child: ExpansionTile(
                    title: Text('Can I export my products for backup?'),
                    children: [
                      textformate(''' 
  The application provides functionality to export your products so that those could be reused as per your requirements.
  On this page, you will get list of all sorted products with pagination.
  You can traverse between pages by clicking on page number and filter products by any column value
                    '''),
                      SizedBox(height: 5),
                      buttonstyle('Export CSV'),
                      SizedBox(height: 5),
                      textformate(
                          '''By clicking on this button,you can download csv file with all products.'''),
                      SizedBox(height: 5),
                      buttonstyle('Export as Procuct Catalogue'),
                      SizedBox(height: 5),
                      textformate('''
  There are various Product Catalogue Template.
  Download Product Catalogue with your Products by selecting your best Product Model Design.
  By clicking on this button, you can download pdf file with all products.''')
                    ],
                  ),
                ),
                Card(
                  elevation: 7,
                  child: ExpansionTile(
                    title: Text('How to import Bulk Product?'),
                    children: [
                      textformate(
                          '''We have made it extremely easy for you to import your products into the Catalouge.
You can import multiple products simultaneously via CSV file by taking following'''),
                      SizedBox(height: 5),
                      buttonstyle('SELECT CSV FILE'),
                      SizedBox(height: 5),
                      textformate(
                          '''You can select csv file from file directory by clicking on this button.
                      '''),
                      SizedBox(height: 5),
                      buttonstyle('DOWNLOAD TEMPLATE'),
                      SizedBox(height: 5),
                      textformate(
                          '''It will be enabled only when u would select csv file.You can upload selected csv file using this button.After uploading csv file succesfully you will see the list of imported products.
                      '''),
                      SizedBox(height: 5),
                      buttonstyle('UPLOAD'),
                      SizedBox(height: 5),
                      textformate(
                          '''By clicking on this button, you can download Products template(Productstemplate.csv file in your file directory) which is just sample template.You can use this template while importing new products.'''),
                    ],
                  ),
                ),
                Card(
                  elevation: 7,
                  child: ExpansionTile(
                    title: Text('How To Clone App Data With Image?'),
                    children: [
                      textformate(''' 
  All of your Image is saved in "Pictures" in 
  $AppName > Product Pictures in Internal Storage
  Then export the data as CSV.
  In other Device that you want to clone Copy this "Picture" folder & save in same location ( Android> data> com.subbu.productcatalogue> files).
  Then Import The Data CSV. 
                    '''),
                      //  Android> data> com.subbu.productcatalogue> files> Pictures.
                    ],
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
