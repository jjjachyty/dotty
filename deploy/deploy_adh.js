const { ethers, upgrades } = require("hardhat");

async function deployed() {
  const ADH = await ethers.getContractFactory('ADH');
  const result=  await upgrades.deployProxy(ADH, { kind: 'uups' });
  console.log("address>>>>>ADH>>>>>",result.address)
}

async function upgraded(){
    
  // Upgrading
  const ADH = await ethers.getContractFactory("ADH");
  const upgraded = await upgrades.upgradeProxy("0x4556C33027Bcf4d42b77B7d65F1677D2AF59Fdea", ADH);
  console.log(upgraded.address);
}
upgraded();