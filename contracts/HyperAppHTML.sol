// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

error NavItemLengthMismatch(uint8 navItemLength,uint8 navItemLinkLength);

contract HyperAppHTML is Ownable {

    struct HTML {
        address  hyperAppDAO;
        Header header;
        string[] navigationItems;
        string[] navigationItemLinks;
    }
    struct Header {
        string title;
        string metaDescription;
    }

    event ChangeHtmlTitle( uint256 indexed id, string title);

    mapping(uint => HTML) public htmls;

    function getHTML(uint id) external view returns(HTML memory){
        return htmls[id];
    }

    function registHTML(uint id, string memory _title, string memory _metaDescription, string[] calldata _navigationItems,string[]  calldata _navigationItemLinks) external payable onlyOwner{
        if (_navigationItems.length != _navigationItemLinks.length) {
            revert NavItemLengthMismatch({
                navItemLength: uint8(_navigationItems.length),
                navItemLinkLength: uint8(_navigationItemLinks.length)
            });
        }
        htmls[id].header.title = _title;
        htmls[id].header.metaDescription = _metaDescription;
        for(uint i = 0; i < _navigationItems.length; i++){
            htmls[id].navigationItems.push(_navigationItems[i]);
            htmls[id].navigationItemLinks.push(_navigationItemLinks[i]);
        }
        
    }

    function addNavItems(uint id, string[] calldata _navigationItems,string[] calldata _navigationItemLinks) external payable onlyOwner{
        if (_navigationItems.length != _navigationItemLinks.length) {
            revert NavItemLengthMismatch({
                navItemLength: uint8(_navigationItems.length),
                navItemLinkLength: uint8(_navigationItemLinks.length)
            });
        }
        for(uint i=0; i < _navigationItems.length; i++){
            htmls[id].navigationItems.push(_navigationItems[i]);
            htmls[id].navigationItemLinks.push(_navigationItemLinks[i]);
        }
    }

    function changeHtmlTitle(uint id,string memory _title)external payable onlyOwner{
        htmls[id].header.title = _title;
    }

    function initNavItem(uint id)external payable onlyOwner{
        htmls[id].navigationItems = new string[](0);
        htmls[id].navigationItemLinks = new string[](0);
    }

    function _changeHtmlTitle(uint _id,string memory _title) private returns(bool){
        htmls[_id].header.title = _title;
        emit ChangeHtmlTitle(_id,_title);
        return true;
    }
}