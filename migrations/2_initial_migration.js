const DibaAir = artifacts.require("DibaAir");

module.exports = async function (deployer) {
  await deployer.deploy(DibaAir, '0xC08969b99547cb5F83a462ACdAEfC5F577Ec7676');
};