import 'package:flutter/material.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';

class MenuCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String description;
  final Widget? screen;

  const MenuCard({
    super.key,
    this.icon, // Сделано необязательным
    required this.title,
    required this.description,
    this.screen, // Сделано необязательным
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (screen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen!),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 50,
                  color: AppColors.backgroundLight,
                ),
              if (icon != null) const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(description,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              if (screen != null)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.backgroundLight,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
