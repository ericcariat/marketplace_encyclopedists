import logo from '../logo_3.png';
import fullLogo from '../full_logo.png';
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  useRouteMatch,
  useParams
} from "react-router-dom";
import { useEffect, useState } from 'react';
import { useLocation } from 'react-router';

function Navbar() {

const [connected, toggleConnect] = useState(false);
const location = useLocation();
const [currAddress, updateAddress] = useState('0x');

async function getAddress() {
  const ethers = require("ethers");
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const signer = provider.getSigner();
  const addr = await signer.getAddress();
  updateAddress(addr);
}

function updateButton() {
  const ethereumButton = document.querySelector('.enableEthereumButton');
  ethereumButton.textContent = "Connected";
  ethereumButton.classList.remove("hover:bg-blue-70");
  ethereumButton.classList.remove("bg-blue-500");
  ethereumButton.classList.add("hover:bg-[#5e60ee]");
  ethereumButton.classList.add("bg-[#918ef5]");
}

// <img src={fullLogo} alt="" width={120} height={120} className="inline-block -mt-2"/>

async function connectWebsite() {

    const chainId = await window.ethereum.request({ method: 'eth_chainId' });
    if(chainId !== '0x5')
    {
      //alert('Incorrect network! Switch your metamask network to Rinkeby');
      await window.ethereum.request({
        method: 'wallet_switchEthereumChain',
        params: [{ chainId: '0x5' }],
     })
    }  
    await window.ethereum.request({ method: 'eth_requestAccounts' })
      .then(() => {
        updateButton();
        console.log("here");
        getAddress();
        window.location.replace(location.pathname)
      });
}

  useEffect(() => {
    let val = window.ethereum.isConnected();
    if(val)
    {
      console.log("here");
      getAddress();
      toggleConnect(val);
      updateButton();
    }

    window.ethereum.on('accountsChanged', function(accounts){
      window.location.replace(location.pathname)
    })
  });

    return (
      <div className="">
        <div className="sidemenu">
          <section id="sideMenu">
            <nav>
              <a href="#" class="active"><i class="fa fa-home" aria-hidden="true"></i>The Encyclopedists</a>
              <a href="/"><i class="fa fa-sticky-note-o" aria-hidden="true"></i>Marketplace</a>
              <a href="/sellNFT"><i class="fa fa-bookmark-o" aria-hidden="true"></i>Publish</a>
              <a href="#"><i class="fa fa-calendar-check-o" aria-hidden="true"></i> DAO</a>
              <a href="#"><i class="fa fa-user-circle-o" aria-hidden="true"></i> Library</a>
              <a href="#"><i class="fa fa-cog" aria-hidden="true"></i> Buy ECL Token</a>
              <a href="/profile"><i class="fa fa-cog" aria-hidden="true"></i> My profile</a>
            </nav>
          </section>

          <header>
            <div class="search-area">
              <i class="fa fa-search" aria-hidden="true"></i>
              <input type="text"></input>
            </div>
            <div class="user-area">
              <a href="#">+ Add</a>
              <a href="#" class="notification"><i class="fa fa-bell-o" aria-hidden="true"></i>
          <span class="circle">3</span></a>
              <a href="#">
                <div class="user-img"></div>
                <i class="fa fa-caret-down" aria-hidden="true"></i>
              </a>
              <button className="enableEthereumButton bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded text-sm" onClick={connectWebsite}>{connected? "Connected":"Connect Wallet"}</button>
   
            </div>
          </header>
        </div>
        
        <div className='text-white text-bold text-right mr-10 text-sm'>
          {currAddress !== "0x" ? "Connected to":"Not Connected. Please login to view NFTs"} {currAddress !== "0x" ? (currAddress.substring(0,50)):""}
        </div>
      </div>
    );
  }

  export default Navbar;