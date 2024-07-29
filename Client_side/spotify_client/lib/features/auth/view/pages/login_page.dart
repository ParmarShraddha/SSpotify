import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spotify_client/core/theme/app_pallete.dart';
import 'package:spotify_client/core/utils.dart';
import 'package:spotify_client/core/widgets/loader.dart';
import 'package:spotify_client/features/auth/view/pages/signup_page.dart';
import 'package:spotify_client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:spotify_client/features/auth/view/widgets/custom_field.dart';
import 'package:spotify_client/features/auth/repositories/auth_remote_repository.dart';
import 'package:spotify_client/features/auth/viewmodel/auth_viewmodel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

 
 @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
    formKey.currentState!.validate();
  }
 @override
 

  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider)?.isLoading == true;
    
    ref.listen(
      authViewModelProvider, 
    (_, next){
      next?.when(
        data:(data) {
          
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context)=> const LoginPage(),
          //      ),
          //      );
        }, 
        error: (error,st){
          showSnackBar(context,error.toString(),);
        }, 
        loading: (){},
      );
    }
    );
     
    return Scaffold(
      appBar: AppBar(),
      body:  isLoading? 
      const Loader()
      :
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 45),

                const Text('Sign In', 
                style:TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  ) ,
                  ),
                  const SizedBox(height: 30),
                 
                  CustomField(hintText: 'Email',controller: emailController,),
                  const SizedBox(height: 15),
                  CustomField(hintText: 'Password',controller: passwordController,isObscureText: true,),
                  const SizedBox(height: 25),
                  AuthGradientButton(
                    buttonText: 'Sign In', 
                    onTap:()async{
                      print("HEllo "+ emailController.text);
                      final res =await AuthRemoteRepository().login(
                        email: emailController.text,
                        password: passwordController.text,
                        );
                        final val = switch(res){
                          Left(value:final l)=>l,
                          Right(value:final r)=>r,
                        };
                        print(val);

                    } ,),
                  
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context)=> const SignupPage()));
                    },
                    child: RichText(
                      text:  TextSpan(
                      text: "Don't have an account?",
                      style: Theme.of(context).textTheme.titleMedium,
                      children: const [
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: Pallete.gradient2,
                            fontWeight: FontWeight.bold
                          )
                          )
                      ]
                    ),
                    ),
                  ),
              ],),
          ),
        ),
      ),
    );
  }
}