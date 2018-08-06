//TODO add methods to check if email/login is taken

import { Injectable, Inject } from '@angular/core';
import { HttpClient, HttpErrorResponse, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';

@Injectable()
export class LoginService {

  constructor(@Inject('LOGIN_URL') private loginApiURL: string, @Inject('SIGNUP_URL') private signupApiURL: string, private http: HttpClient) { }

  LogIn(email: string, password: string): Observable<any> {
    let observable: Observable<any> = this.http.post(this.loginApiURL,
      { email: email, password: password },
      { responseType: 'text' });
    return observable;
  }

  SignUp(login: string, email: string, password: string): Observable<any> {
    console.log(this.signupApiURL);
    let observable: Observable<any> = this.http.post(this.signupApiURL,
      { email: email, password: password, login:login},
      { responseType: 'text' });
    return observable;
  }

 }
