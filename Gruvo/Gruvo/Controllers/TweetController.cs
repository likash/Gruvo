﻿using System;
using Gruvo.BLL;
using Gruvo.DAL.Repository;
using Gruvo.DTL;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Gruvo.Controllers
{
    [Authorize(Policy ="GruvoCookie")]
    [Route("api/[controller]")]
    public class TweetController : ControllerBase
    {
        private BaseRepository _repository;
        private ITokenUserPairs _tokenUserPairs;

        public TweetController(BaseRepository repository, ITokenUserPairs tokenUserPairs)
        {
            _repository = repository;
            _tokenUserPairs = tokenUserPairs;
        }

        [HttpGet("like")]
        public IActionResult Like([FromQuery] long tweetId)
        {
            try
            {
                if (tweetId < 1)
                {
                    return BadRequest();
                }

                long userId = _tokenUserPairs.Pairs[Request.Cookies["Gruvo"]].Id;

                if (_repository.TweetDAO.Dislike(tweetId, userId) == 0)
                {
                    _repository.TweetDAO.Like(tweetId, userId);
                }

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest("Something went wrong");
            }
        }

        [HttpGet("tweetLikes")]
        public IActionResult GetLikes([FromQuery] long tweetId)
        {
            try
            {
                if (tweetId < 1)
                {
                    return BadRequest();
                }

                return Ok(_repository.TweetDAO.GetNumOfLikes(tweetId));
            }
            catch (Exception ex)
            {
                return BadRequest("Something went wrong");
            }
        }

        [HttpGet("checkLiked")]
        public IActionResult CheckLiked([FromQuery] long tweetId)
        {
            try
            {
                if (tweetId < 1)
                {
                    return BadRequest();
                }

                long userId = _tokenUserPairs.Pairs[Request.Cookies["Gruvo"]].Id;

                return Ok(_repository.TweetDAO.CheckIfUserLiked(tweetId, userId));
            }
            catch (Exception ex)
            {
                return BadRequest("Something went wrong");
            }
        }

        [HttpPost]
        [Route("addcomment")]
        public IActionResult AddComment([FromBody] Comment comment)
        {
            try
            {
                long userId = _tokenUserPairs.Pairs[Request.Cookies["Gruvo"]].Id;
                _repository.TweetDAO.AddComment(comment.TweetId, userId, comment.Message, DateTime.Now);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest("Something went wrong");
            }
        }

        [HttpGet("comments")]
        public IActionResult GetComments([FromQuery] long tweetId)
        {
            try
            {
                if (tweetId < 1)
                {
                    return BadRequest();
                }
                long userId = _tokenUserPairs.Pairs[Request.Cookies["Gruvo"]].Id;
                return Ok(_repository.TweetDAO.GetComments(tweetId, userId));
            }
            catch (Exception ex)
            {
                return BadRequest("Something went wrong");
            }
        }

        [HttpPost]
        [Route("deletecomment")]
        public IActionResult DeleteComment([FromBody] long commentid)
        {
            try
            {
                long userId = _tokenUserPairs.Pairs[Request.Cookies["Gruvo"]].Id;
                long commentOwnersId = _repository.TweetDAO.GetComment(commentid).UserId;
                if (commentOwnersId == userId)
                {
                    _repository.TweetDAO.DeleteComment(commentid);
                }
                else
                {
                    throw new Exception();
                }
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest("Something went wrong");
            }
        }
    }
}