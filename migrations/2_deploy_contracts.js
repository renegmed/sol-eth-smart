var myToken = artifacts.require("./MyToken.sol");

module.exports = function(deployer) {
    deployer.deploy(myToken, 21000000, "My Token", "MT");
};