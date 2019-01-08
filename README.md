# MoneroBox
MoneroBox aims to be a zero-configuration, plug-and-plug Monero full node.  
The box is running on a Single-Board-Computer Rock64 with SSD.  
Users can monitor the box with web browser and use it as a remote node for Monero GUI on destktop / Cake wallet / Monerujo.  
Software such as monero command line tools and web UI will be updated automatically.  

## Features  

* Plug-and-play by utilizing zero-configuration network, user don't need to SSH or anything, just plug the ethernet cable and power cable  
* Auto update new monero cli tools and web UI from a apt repository  
* Web-based monitoring UI  
* Web-based management UI for monero daemon  

## Hardware  

Rock64 + SSD: Rock64 1GB has an ARM 64-bit processor, lower price and USB 3 port! The powerful CPU and SSD enables moenrobox to sync the blockchain from scratch in about 25 hours(depends on network and memory). 

## Software
Monerobox is designed to be easy to use and friendly to beginners. Monitoring and Administration can be done with web UI([RPi-Monitor-Monerobox](https://github.com/Jasonhcwong/RPi-Monitor-Monerobox)) accessed on a mobile phone. Users are recommended to use monerobox as a remote node and connect their mobile wallets to it. Thus coins are stored on the mobile wallets on mobile phones not monerobox so that their fund will be safe even if monerobox is being hacked or destroyed.

## Credit
Monerobox is developed based many other open-source software including:  
* [Monero CLI tools by Monero project](https://github.com/monero-project/monero)
* [RPI-Monitor by Xavier Berger](https://github.com/XavierBerger/RPi-Monitor)
* [Rock64 Linux by ayufan](https://github.com/ayufan-rock64/linux-build)
