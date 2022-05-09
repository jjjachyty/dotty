const { ethers, upgrades } = require('hardhat');




describe('DOTTY', function () {
  it('deploys', async function () {

    // const DOTTY = await ethers.getContractFactory('DOTTY');
    // const result=  await upgrades.deployProxy(DOTTY, { kind: 'uups' });
    // console.log("address>>>>>DOTTY>>>>>",result.address)

    const DOTTY = await ethers.getContractFactory("DOTTY");
    const upgraded = await upgrades.upgradeProxy("0xa431fec95687e2ea4e910eFFc406eB8971EC709D", DOTTY);
    console.log(upgraded.address);

    
  });
});