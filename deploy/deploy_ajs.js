const { ethers, upgrades } = require("hardhat");

async function deployed() {
  const AJS = await ethers.getContractFactory('AJS');
  const result=  await upgrades.deployProxy(AJS, { kind: 'uups' });
  console.log("address>>>>>AJS>>>>>",result.address)
}

async function upgraded(){
    
  // Upgrading
  const AJS = await ethers.getContractFactory("AJS");
  const upgraded = await upgrades.upgradeProxy("0x8814E17E8390B443FB0fe4df6327E433dd1C708E", AJS);
  console.log(upgraded.address);
}
upgraded();