/// A social account shown on the home page.
class Sns {
  const Sns({required this.name, required this.username, required this.url, required this.image});

  final String name;
  final String username;
  final String url;

  /// The file name part shared by the `qr_*.png` and `logo_*_{light,dark}.png` images.
  final String image;
}

const snsAccounts = [
  Sns(name: 'GitHub', username: '0-terarin-0', url: 'https://github.com/0-terarin-0', image: 'github'),
  Sns(
    name: 'Instagram',
    username: '_0_terarin_0_',
    url: 'https://www.instagram.com/_0_terarin_0_/',
    image: 'instagram',
  ),
  Sns(name: 'X', username: '_0_terarin_0_', url: 'https://twitter.com/_0_terarin_0_/', image: 'x'),
  Sns(name: 'Qiita', username: '0_terarin_0', url: 'https://qiita.com/0_terarin_0', image: 'qiita'),
  Sns(name: 'Zenn', username: '0_terarin_0', url: 'https://zenn.dev/0_terarin_0', image: 'zenn'),
  Sns(
    name: 'LinkedIn',
    username: '0-terarin-0-',
    url: 'https://www.linkedin.com/in/0-terarin-0-',
    image: 'linkedin',
  ),
];
