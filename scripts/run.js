const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const nftContract =  await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log(`Deployed NFT contract at ${nftContract.address}`);

    // calling the function
    let txn = await nftContract.makeAnEpicNFT()
    await txn.wait();

    //mint another nft for fun
    txn = await await nftContract.makeAnEpicNFT()
    await txn.wait();

};

const runMain = async () => {
    try{
        await main();
        process.exit(0);
    } catch(error){
        console.error(error);
        process.exit(1);
    }
}

runMain();