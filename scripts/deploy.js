const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log(`Deployed NFT contract at ${nftContract.address}`);


    // call the function to mint a new token
    let txn = await nftContract.makeAnEpicNFT()
    await txn.wait();
    console.log("minted nft #1")

     txn = await nftContract.makeAnEpicNFT()
    await txn.wait();
    console.log("minted nft #2")
};

const runMain = async () => {
    try{
        await main();
        process.exit(0);
    } catch(error) {
        console.log(error)
        process.exit(1);
    }
};

runMain();