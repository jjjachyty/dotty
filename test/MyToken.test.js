const { ethers, upgrades } = require('hardhat');




describe('DAPP', function () {
  it('deploys', async function () {

  const DAPP = await ethers.getContractFactory('DAPP');
  const result=  await upgrades.deployProxy(DAPP, { kind: 'uups' });
  console.log("address>>>>>DAPP>>>>>",result.address)


  // const ADH = await ethers.getContractFactory("ADH");
  // const upgraded = await upgrades.upgradeProxy("0xA61cA8d36b29B8920dD9aB3E61BAFf23eB5463eE", ADH);
  // console.log(upgraded.address);


  //   const AJS = await ethers.getContractFactory('AJS');
  // const result=  await upgrades.deployProxy(AJS, { kind: 'uups' });
  // console.log("address>>>>>>AJS>>>>",result.address)


  // const AJS = await ethers.getContractFactory("AJS");
  // const upgraded = await upgrades.upgradeProxy("0x4d67D4324cef36C2d6c4dc17e33b38beD1CCd7Cc", AJS);
  // console.log(upgraded.address);

    });
});