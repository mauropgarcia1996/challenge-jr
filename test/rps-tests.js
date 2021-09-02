const { expect, should } = require("chai");
const { ethers } = require("hardhat");

describe("RockPaperScissors", () => {
  describe("RockPaperScissors Contract", () => {
    let RPSContractFactory;
    let RPSContract;
    let address1;
    let address2;
    let address3;

    beforeEach(async () => {
      [address1, address2, address3] = await ethers.getSigners();

      RPSContractFactory = await ethers.getContractFactory("RockPaperScissors");
      RPSContract = await RPSContractFactory.connect(address1).deploy();
      await RPSContract.deployed();

      console.log("RPSContract deployed to: " + RPSContract.address);
    });

    it("Contract should have 2.0 Ether when two users enrolls", async () => {
      let enrollTx1 = await RPSContract.connect(address2).enroll({
        value: ethers.utils.parseEther("1.0"),
      });
      let enrollTx2 = await RPSContract.connect(address3).enroll({
        value: ethers.utils.parseEther("1.0"),
      });

      await enrollTx1.wait();
      await enrollTx2.wait();

      const balance = await ethers.provider.getBalance(RPSContract.address);

      // Contract must have 2.0 Ether.
      expect(ethers.utils.formatEther(balance)).to.equal(
        ethers.utils.formatEther(ethers.utils.parseEther("2.0"))
      );
    });

    it("User should not be able to play without enrolling first", async () => {
      let error = null;
      
      try {
        await RPSContract.connect(address2).play(1);
      } catch (err) {
        error = err
      }

      // Error should not be null.
      expect(error).not.equal(null)
    });
  });
});
