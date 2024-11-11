// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MiniSocial {
    struct Post {
        string message;
        address author;
        uint likes;
        uint dislikes;
        uint createdAt;
        uint modifiedAt;
        mapping(address => bool) likedBy;  // Tracks accounts that liked this post
        mapping(address => bool) dislikedBy;  // Tracks accounts that disliked this post
    }

    Post[] public posts;

    function publishPost(string memory _message) public {
        Post storage newPost = posts.push();
        newPost.message = _message;
        newPost.author = msg.sender;
        newPost.likes = 0;
        newPost.dislikes = 0;
        newPost.createdAt = block.timestamp;
        newPost.modifiedAt = 0;
    }

    function likePost(uint index) public {
        require(index < posts.length, "Post does not exist.");
        Post storage post = posts[index];
        require(!post.likedBy[msg.sender], "You have already liked this post.");
        require(!post.dislikedBy[msg.sender], "Remove dislike before liking.");

        post.likedBy[msg.sender] = true;
        post.likes += 1;
    }

    function dislikePost(uint index) public {
        require(index < posts.length, "Post does not exist.");
        Post storage post = posts[index];
        require(!post.dislikedBy[msg.sender], "You have already disliked this post.");
        require(!post.likedBy[msg.sender], "Remove like before disliking.");

        post.dislikedBy[msg.sender] = true;
        post.dislikes += 1;
    }

    function removeLike(uint index) public {
        require(index < posts.length, "Post does not exist.");
        Post storage post = posts[index];
        require(post.likedBy[msg.sender], "You haven't liked this post.");

        post.likedBy[msg.sender] = false;
        post.likes -= 1;
    }

    function removeDislike(uint index) public {
        require(index < posts.length, "Post does not exist.");
        Post storage post = posts[index];
        require(post.dislikedBy[msg.sender], "You haven't disliked this post.");

        post.dislikedBy[msg.sender] = false;
        post.dislikes -= 1;
    }

    function getPost(uint index) public view returns (string memory, address, uint, uint, uint, uint) {
        require(index < posts.length, "Post does not exist.");
        Post storage post = posts[index];
        return (post.message, post.author, post.likes, post.dislikes, post.createdAt, post.modifiedAt);
    }

    function modifyPost(uint index, string memory _newMessage) public {
        require(index < posts.length, "Post does not exist.");
        require(posts[index].author == msg.sender, "Only the author can modify the post.");
        
        posts[index].message = _newMessage;
        posts[index].modifiedAt = block.timestamp;
    }

    function getTotalPosts() public view returns (uint) {
        return posts.length;
    }
}