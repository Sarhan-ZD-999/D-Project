import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class BrandAndCategoryProductScreen extends StatelessWidget {
  final bool isBrand;
  final String id;
  final String? name;
  final String? image;
  const BrandAndCategoryProductScreen({Key? key, required this.isBrand, required this.id, required this.name, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(isBrand, id, context);
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

            CustomAppBar(title: name),

            isBrand ? Container(height: 100,
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              color: Theme.of(context).highlightColor,
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                FadeInImage.assetNetwork(
                  placeholder: Images.placeholder, width: 80, height: 80, fit: BoxFit.cover,
                  image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.brandImageUrl}/$image',
                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, width: 80, height: 80, fit: BoxFit.cover),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),


                Text(name!, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              ]),
            ) : const SizedBox.shrink(),

            const SizedBox(height: Dimensions.paddingSizeSmall),

            // Products
            productProvider.brandOrCategoryProductList.isNotEmpty ?  Expanded(
              child:
              // SizedBox.shrink()
              StaggeredGridView.countBuilder(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                itemCount: productProvider.brandOrCategoryProductList.length,
                shrinkWrap: true,
                staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                itemBuilder: (BuildContext context, int index) {
                  return ProductWidget(productModel: productProvider.brandOrCategoryProductList[index]);
                },
              ),
            ) :

            Expanded(child: Center(child: productProvider.hasData! ?

              ProductShimmer(isHomePage: false,
                isEnabled: Provider.of<ProductProvider>(context).brandOrCategoryProductList.isEmpty)
                : const NoInternetOrDataScreen(isNoInternet: false),
            )),

          ]);
        },
      ),
    );
  }
}