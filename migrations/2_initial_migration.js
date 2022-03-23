const DibaAir = artifacts.require("DibaAir");

module.exports = async function (deployer) {
  await deployer.deploy(DibaAir, '0x6F09A51643a20777A6901e24555C8a7BE3163997');
};