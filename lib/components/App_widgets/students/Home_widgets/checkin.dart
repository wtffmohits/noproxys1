import 'package:flutter/material.dart';

class Checkins extends StatelessWidget {
  const Checkins({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ResponsiveRow(
            children: [
              _buildCheckInCard(context, "Checkin", Icons.call_received_sharp),
              const SizedBox(width: 15),
              _buildCheckInCard(context, "Checkout", Icons.call_made_rounded),
            ],
          ),
          const SizedBox(height: 10),
          ResponsiveRow(
            children: [
              _buildCheckInCard(context, "Brack", Icons.call_received_sharp),
              const SizedBox(width: 15),
              _buildCheckInCard(context, "Launch", Icons.call_made_rounded),
            ],
          ),
        ]
      ),
    );
  }

  Widget _buildCheckInCard(BuildContext context, String title, IconData icon) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Colors.blue,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.data_exploration_rounded,
                  size: 20,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.7, // Adjust width based on screen size
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 224, 228, 231),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TimeOfDay.now().format(context),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: .5),
              child: Row(
                children: [
                  Text(
                    title == "Checkin" ? "Checked is Sucess!" : "Checkout is Sucess!",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponsiveRow extends Row {
  const ResponsiveRow({super.key, required super.children})
      : super(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
        );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children.map((child) => Flexible(child: child)).toList(),
    );
  }
}