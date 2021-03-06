﻿using System;
using System.Collections.Generic;
using Gruvo.DTL;

namespace Gruvo.DAL
{
    public interface ITweetDAO
    {
        void AddPost(long userId, string message, DateTime sendingDateTime);

        IEnumerable<ReadableTweet> GetPostsBatchForUser(long id, DateTimeOffset date);

        IEnumerable<ReadableTweet> GetPostsForUser(long id);
        IEnumerable<ReadableTweet> GetUserPosts(long id, bool otherUser);

        Int32 GetUserPostsCount(long id);

        void DeletePost(long id);

        void AddComment(long tweetId, long userId, string message , DateTime sendingDateTime);

        IEnumerable<Comment> GetComments(long tweetId,long userId);

        Comment GetComment(long commentid);

        void DeleteComment(long commentId);

        /// <summary>
        /// Returns number of affected rows
        /// </summary>
        /// <param name="postId">Tweet id</param>
        /// <param name="userId">User id</param>
        /// <returns></returns>
        int Like(long postId, long userId);

        /// <summary>
        /// Returns number of affected rows
        /// </summary>
        /// <param name="postId">Tweet id</param>
        /// <param name="userId">User id</param>
        /// <returns></returns>
        int Dislike(long postId, long userId);

        /// <summary>
        /// Returns number of likes
        /// </summary>
        /// <param name="id">Tweet id</param>
        /// <returns></returns>
        int GetNumOfLikes(long id);

        /// <summary>
        /// Returns true if user liked this tweet, false if not
        /// </summary>
        /// <param name="postId">Tweet id</param>
        /// <param name="userId">User id</param>
        /// <returns></returns>
        bool CheckIfUserLiked(long postId, long userId);

        /// <summary>
        /// Returns true if user has tweet with specified id, false if not
        /// </summary>
        /// <param name="postId">Tweet id</param>
        /// <param name="userId">User id</param>
        /// <returns></returns>
        bool CheckIfUserHasTweet(long postId, long userId);
    }
}
