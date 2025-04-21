import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

//ignore: must_be_immutable
class PieChartSample extends StatelessWidget {
  Map<String, double> dataMap = {
    "BIDA": 4,
    "IS": 3,
    "ITIM": 4,
    "GIS": 2,
    "SPM": 1.5,
  };
  List<Color> colorsList = [
    Colors.blue,
    Colors.orange,
    Colors.deepPurpleAccent,
    Colors.greenAccent,
    Colors.redAccent,
  ];

  PieChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Pie Chart"),
        centerTitle: true,
      ),
      body: Center(
        child: PieChart(
          colorList: colorsList,
          dataMap: dataMap,
          chartType: ChartType.ring,
          chartLegendSpacing: 10,
          chartRadius: MediaQuery.of(context).size.width / 1.2,
          legendOptions: const LegendOptions(
            legendPosition: LegendPosition.bottom,
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValuesInPercentage: true,
            showChartValuesOutside: true,
          ),
        ),
      ),
    );
  }
}
