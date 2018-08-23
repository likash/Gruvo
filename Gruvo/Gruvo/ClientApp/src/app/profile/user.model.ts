export interface IUser {
  id:number;
  login: string;
  regDate: Date;
  followers: number;
  followings: number;
  posts: number;
  about?: string;
  birthDay?: Date;
  }