import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../data/providers/config_provider.dart';

class AnimalesListScreen extends StatelessWidget{
  const AnimalesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    return Text(configProvider.getEndpointUrl('animales'));
  }
}