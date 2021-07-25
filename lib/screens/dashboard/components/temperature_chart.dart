import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

/*
currently not using this as it is not UI friendly not able to squeeze the
area this widget takes.
 */


class TemperatureChart extends StatelessWidget {
  const TemperatureChart({
    Key? key,
    required this.currentTemp,
  }) : super(key: key);

  final double currentTemp;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      backgroundColor: Colors.white12,
      axes: <RadialAxis>[RadialAxis(
        useRangeColorForAxis: true,
        canScaleToFit: true,
        // startAngle: 0,
        // endAngle: 0,
        showLabels: false,
        minimum: 0,
        maximum: 60,
        interval: 1,
        majorTickStyle: MajorTickStyle(
            length: 10
        ),
        minorTicksPerInterval: 0,
        showAxisLine: false,
        ranges: [
          GaugeRange(
            startValue: 0,
            endValue: currentTemp,
            color: Colors.green,
            // gradient: SweepGradient(
            //   colors: [
            //     Colors.white,
            //     Colors.red
            //   ]
            // ),
          ),
        ],
        annotations: [
          GaugeAnnotation(
              // verticalAlignment: GaugeAlignment.far,
              // horizontalAlignment: GaugeAlignment.center,
              positionFactor: 0,
              widget: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${currentTemp.toStringAsFixed(0)}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60
                    ),
                  ),
                  Text(
                    " \u00B0C",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,

                    ),
                    // textAlign: TextAlign.justify,
                  )
                ],
              )

          ),
        ],
        pointers: [
          MarkerPointer(
            color: Colors.green,
            value: currentTemp,
            markerWidth: 30,
            markerHeight: 1,
            markerType: MarkerType.rectangle,
          )
        ],

      )],
    );
  }
}
