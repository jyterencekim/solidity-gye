var Gye = artifacts.require("Gye");

module.exports = function(deployer) {
  deployer.deploy(Gye, "Test", "For the sake of testing", 10);
};
