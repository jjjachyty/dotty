const { ethers, upgrades } = require("hardhat");

async function deployed() {
  const Pledgemining = await ethers.getContractFactory('Pledgemining');
  const result=  await upgrades.deployProxy(Pledgemining, { kind: 'uups' });
  console.log("address>>>>>Pledgemining>>>>>",result.address)
}

async function upgraded(){
    
  // Upgrading
  const Pledgemining = await ethers.getContractFactory("Pledgemining");
  const upgraded = await upgrades.upgradeProxy("0xfeE2B1B8B5C77f89418Ce94c6A6FA79e9870191A", Pledgemining);
  console.log(upgraded.address);
}
deployed();