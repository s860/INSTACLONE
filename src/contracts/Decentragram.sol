pragma solidity ^0.5.0;

contract Decentragram {
 string public name = "Decentragram";
 //store images
 uint public imageCount = 0;
 mapping(uint => Image) public images;

 struct Image {
 uint id;
 string hash;
 string description;
 uint tipAmount;
 address payable author;
 }

 event ImageCreated(
 uint id,
 string hash,
 string description,
 uint tipAmount,
 address payable author
 );

 event ImageTipped(
 uint id,
 string hash,
 string description,
 uint tipAmount,
 address payable author
 );

 //create images
 function uploadImage(string memory _imgHash,string memory _description) public{
 //make sure image description , image hash and address of the uploader exists
 require(bytes(_description).length > 0);
 require(bytes(_imgHash).length > 0);

 require(msg.sender!=address(0));

//increment image id
imageCount++;

 //add image to contract 
 	images[imageCount]=Image(imageCount,_imgHash,_description,0, msg.sender);
 	//trigger the event
 	emit ImageCreated(imageCount,_imgHash,_description,0,msg.sender);
 }
 //Tip post  
 function tipImageOwner(uint _id) public payable{
 require(_id > 0 && _id < imageCount);
//fetch the image
 Image memory _image = images[_id];
 //fetch the author
 address payable _author = _image.author;
 //transferring the maount 
 address(_author).transfer(msg.value);
 //increment the tip maount
 _image.tipAmount = _image.tipAmount + msg.value;
 images[_id]= _image;
 emit ImageTipped(_id, _image.hash, _image.description ,_image.tipAmount, _author);

 }
}