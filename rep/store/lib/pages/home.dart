import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:smartstore2/design/colors.dart';
import 'package:smartstore2/design/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smartstore2/pages/profilepage.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          'Профиль',
          style: TextStyle(fontSize: firstfont),
        ),
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(auth),
                const SizedBox(height: 5),
                _buildMenuList(context, auth),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(AuthProvider auth) {
    final userData = auth.userData;
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: primaryColor,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white24,
            ),
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData?['name'] ?? 'Загрузка...',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                userData?['email'] ?? '',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, AuthProvider auth) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: surfaceColor,
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.person_outline,
            title: 'Мой профиль',
            subtitle: 'Измените данные учетной записи',
            index: 0,
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.list,
            title: 'Список продуктов',
            subtitle: 'Просматривайте ваши покупки',
            index: 1,
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.receipt_long,
            title: 'Ваши покупки',
            subtitle: 'Просматривайте ваши чеки здесь',
            index: 2,
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: 'Выход',
            subtitle: 'Выйти из учетной записи',
            index: 3,
            onTap: () async {
              await auth.logout();
              Navigator.pushReplacementNamed(context, '/L');
            },
          ),
          const Divider(color: backgroundColor, thickness: 6),
          _buildMenuItem(
            context,
            icon: Icons.help_outline,
            title: 'Помощь и поддержка',
            index: 4,
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            title: 'О нашем приложении',
            index: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
        color: primaryVarColor, thickness: 2, indent: 20, endIndent: 20);
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      String subtitle = '',
      required int index,
      VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: primaryColor, size: 28),
      title: Text(
        title,
        style: const TextStyle(fontSize: mainfont, color: textColor),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(subtitle,
              style: const TextStyle(fontSize: subfont, color: Colors.blueGrey))
          : null,
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap ?? () {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
            break;
          case 1:
            Navigator.pushNamed(context, '/B');
            break;
          case 2:
            Navigator.pushNamed(context, '');
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SupportPage()),
            );
            break;
          case 5:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutPage()),
            );
            break;
          default:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailPage(index: index)),
            );
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class DetailPage extends StatelessWidget {
  final int index;

  const DetailPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Подробности $index')),
      body: Center(
        child: Text(
          'Вы выбрали пункт с индексом: $index',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Помощь и поддержка')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black87),
              children: [
                const TextSpan(
                    text:
                        'Если у вас есть вопросы, свяжитесь с нами по электронной почте: '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse(
                          'gejnmaks886@gmail.com')); // Замените на свою почту
                    },
                    child: const Text(
                      'gejnmaks886@gmail.com',
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('О нашем приложении')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RichText(
          text: TextSpan(
            style:
                TextStyle(fontSize: 18, color: Colors.black), // базовый стиль
            children: [
              TextSpan(
                text: 'Описание:\n',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    '"Умный магазин" - это Android приложение, спроектированное для осуществления очных покупок в магазинах, без взаимодействия с кассирами и кассами самообслуживания.\n\n',
              ),
              TextSpan(
                text: 'Возможности:\n',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text:
                    '* Вход/Регистрация аккаунта\n* Подключение любого магазина/сети магазинов к приложению'
                    '\n* Регистрация/Вход по электронной почте'
                    '\n* Отдельный аккаунт продавца, в котором он может отслеживать наличие товара и добавлять новый'
                    '\n* Список доступных товаров покупателю'
                    '\n* Сканирование штрихкода товара для добавления в корзину и дальнейшей оплаты',
              )
            ],
          ),
        ),
      ),
    );
  }
}
