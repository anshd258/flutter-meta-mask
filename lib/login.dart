import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var connect = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'My App',
          description: 'An app for converting pictures to NFT',
          url: 'https://ans.org',
          icons: [
            'https://d33wubrfki0l68.cloudfront.net/f9bf7321ed7d9045fac8e374993c9420fe730b45/121d3/static/6b935ac0e6194247347855dc3d328e83/13c43/eth-diamond-black.png'
          ]));
  var _session, _uri;

  loginUsingMetamask(BuildContext context) async {
    if (!connect.connected) {
      try {
        var session = await connect.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        setState(() {
          _session = session;
        });
      } catch (exp) {
        print(exp);
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    connect.on(
        'connect',
        (session) => setState(
              () {
                _session = _session;
                print(_session.accounts[0]);
                print(_session.chainId);
              },
            ));
    connect.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;
              print(_session.accounts[0]);
              print(_session.chainId);
            }));
    connect.on(
        'disconnect',
        (payload) => setState(() {
              _session = null;
            }));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://d33wubrfki0l68.cloudfront.net/f9bf7321ed7d9045fac8e374993c9420fe730b45/121d3/static/6b935ac0e6194247347855dc3d328e83/13c43/eth-diamond-black.png',
              fit: BoxFit.fitHeight,
            ),
            ElevatedButton(
                onPressed: () => loginUsingMetamask(context),
                child: const Text("Connect with Metamask"))
          ],
        ),
      ),
    );
  }
}
