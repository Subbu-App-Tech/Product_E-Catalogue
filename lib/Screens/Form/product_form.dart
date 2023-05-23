import 'package:flutter/material.dart';
import 'package:productcatalogue/Screens/Form/brand_sugs.dart';
import 'package:productcatalogue/Screens/Form/image_handle.dart';
import 'package:productcatalogue/Screens/Form/text_box.dart';
import 'package:productcatalogue/adMob/my_ad_mod.dart';
import '../../Tool/DynamicTextField.dart';
import '../../Tool/MultiSelectedChip.dart';
import '../../export.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAEForm extends StatelessWidget {
  static const routeName = '/user-AE-Form';
  const UserAEForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _prodid = ModalRoute.of(context)!.settings.arguments as String?;
    final _product = Provider.of<ProductData>(context).findbyid(_prodid) ??
        Product(
            imagepathlist: [],
            id: '${UniqueKey()}_${DateTime.now().microsecondsSinceEpoch}',
            name: '',
            categories: []);
    return ProductForm(product: _product);
  }
}

class ProductForm extends StatefulWidget {
  final Product product;
  const ProductForm({super.key, required this.product});
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  GlobalKey key = new GlobalKey();
  late SnackBar snackBar;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  var edit = false;
  final form = GlobalKey<FormState>();
  late Product _product;

  @override
  void didChangeDependencies() {
    _product = widget.product;
    edit = _product.name.isEmpty;
    if (_product.varieties.isEmpty) _product.addEmptyVariety();
    super.didChangeDependencies();
  }

  Widget _exitwithoutvariety(BuildContext context) {
    return AlertDialog(
      title: Text('Atleast Add One Variety'),
      actions: [
        ElevatedButton(
            child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.pop(context))
      ],
    );
  }

  void _saveform() async {
    final isValid = form.currentState!.validate();
    _product.varieties.removeWhere((e) => e.name.isEmpty);
    if (_product.varieties.length <= 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) => _exitwithoutvariety(context));
    } else {
      if (!isValid) return;
      form.currentState!.save();
      await Provider.of<ProductData>(context, listen: false)
          .addproduct(_product);
      edit = !edit;
      Navigator.of(context).pop();
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('SaveCount') ?? 0;
    if (count > 4) {
      await MyMobAd().showInterstitialAd();
      count = 0;
    } else {
      count++;
    }
    prefs.setInt('SaveCount', count);
  }

  void _startaddingcat(BuildContext context) async {
    String? catName = await showModalBottomSheet(
        context: context,
        builder: (_) {
          final TextEditingController _textcont = TextEditingController();
          return Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Category Name'),
                  controller: _textcont,
                  onSubmitted: (_) => Navigator.pop(context, _textcont.text),
                ),
                ElevatedButton(
                  child: Text('Add Category'),
                  onPressed: () => Navigator.pop(context, _textcont.text),
                ),
              ],
            ),
          );
        });
    if (catName != null && catName.isNotEmpty) {
      _product.addCategIfNotExist(catName);
      _categBoxKey.currentState?.setState(() {});
    }
  }

  GlobalKey _varKey = GlobalKey();
  GlobalKey _categBoxKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    List<String> categList = _product.categories;
    return Scaffold(
      key: _scaffoldkey,
      appBar:
          AppBar(title: (edit) ? Text('Edit Product') : Text("Add Product")),
      body: Form(
        key: form,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: <Widget>[
            ProductImageHandle(product: _product),
            MyTextFormBox<String>(
                title: 'Product Name *',
                value: _product.name,
                onChange: _product.updatename,
                isNullable: false,
                validate: true),
            MyTextFormBox<String?>(
                title: 'Product Details',
                value: _product.description,
                onChange: _product.updatedescription,
                maxLines: 4),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 4, child: BrandSuggessionBx(product: _product)),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 1,
                    child: MyTextFormBox<int>(
                        title: 'Rank',
                        value: _product.rank ?? 100,
                        onChange: _product.updaterank),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(border: Border.all()),
              color: Colors.grey[250],
              child: Column(
                children: <Widget>[
                  (categList.length == 0)
                      ? Text('No Category Available')
                      : Text('Select Product Category'),
                  Divider(),
                  MultiSelectChip(product: _product, key: _categBoxKey),
                  ElevatedButton(
                      onPressed: () => _startaddingcat(context),
                      child: Text('Add Category'))
                ],
              ),
            ),
            SizedBox(height: 10),
            if (_product.varieties.isEmpty)
              Container(
                  child: Text(' Product Varieties',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center),
                  width: double.infinity),
            Container(
              padding: EdgeInsets.all(5),
              child: StatefulBuilder(
                  key: _varKey,
                  builder: (context, setst) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _product.varieties.length,
                      itemBuilder: (build, index) {
                        return DynamicTextForm(
                            variety: _product.varieties[index],
                            delete: () =>
                                setst(() => _product.varieties.removeAt(index)),
                            keyform: form);
                      },
                      shrinkWrap: true,
                    );
                  }),
            ),
            ElevatedButton(
                onPressed: () {
                  _product.addEmptyVariety();
                  _varKey.currentState?.setState(() {});
                },
                child: Text('Add New Variety')),
            SizedBox(height: 150)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text('Save Product'),
          icon: Icon(Icons.save),
          onPressed: _saveform),
    );
  }
}
