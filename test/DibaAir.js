const { expect } = require("chai");
const { web3 } = require("@openzeppelin/test-helpers/src/setup");

const fromWei = (n) => web3.utils.fromWei(n.toString());
const bn2String = (bn) => fromWei(bn.toString());
const toWei = (n) => web3.utils.toWei(n.toString());

const DibaAir = artifacts.require("DibaAir");

require("chai")
  .use(require("chai-as-promised"))
  .should()

contract("DibaAir", (accounts) => {
  let token;

  describe('DibaAir', () => {
    before(async () => {
      token = await DibaAir.new(accounts[1]);
    });

    it("Should set the right owner", async () => {
      expect(await token.owner()).to.equal(accounts[0]);
    });

    it("Claim airdrop", async function () {
      await token.airdrop(accounts[3], { from: accounts[3], value: toWei(0.0031), gas: 3000000 });
      expect(bn2String(await token.balanceOf(accounts[3]))).to.equal('1000');
    });
  });
});