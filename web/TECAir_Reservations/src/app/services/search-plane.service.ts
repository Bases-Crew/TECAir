import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from 'src/environment';
import { SearchStop } from '../models/search-stop.model';

@Injectable({
  providedIn: 'root',
})
export class SearchPlaneService {
  private url: string = environment.apiUrl;

  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
      Authorization: 'my-auth-token',
    }),
  };

  constructor(private http: HttpClient) {}

  public getSeeFlights(): Observable<SearchStop[]> {
    return this.http.get<SearchStop[]>(this.url + 'api/see-flights');
  }
}
