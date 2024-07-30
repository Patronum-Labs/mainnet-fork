import { expect } from "chai";
import { ethers } from "hardhat";
import { ERC777LockBox, ReversibleICOToken } from "../typechain-types";

const LYXeHolders = [
  "0xde8531C4FDf2cE3014527bAF57F8f788E240746e",
  "0x09363887A4096b142f3F6b58A7eeD2F1A0FF7343",
  "0x3022eb3691fdf020f6eaf85ef28569f7b6a518ea",
  "0xd08D3fc1fd5F82E86f71733a5B6f4731938e76F3",
  "0x5a94809ed5e3d4f5c632141100b76ce04f94380f",
  "0xf35a6bd6e0459a4b53a27862c51a2a7292b383d1",
];

const LYXE_ADDRESS = "0xA8b919680258d369114910511cc87595aec0be6D";

const ETH_HOLDER_WITHOUT_LYXE = "0x189b9cbd4aff470af2c0102f365fc1823d857965";

describe("ERC777LockBox Contract Tests", async () => {
  let LYXeContract: ReversibleICOToken;
  let lockbox: ERC777LockBox;
  let lockboxContractDeployer: any;

  beforeEach(async () => {
    lockboxContractDeployer = await ethers.getImpersonatedSigner(
      ETH_HOLDER_WITHOUT_LYXE,
    );

    // LYXe contract
    LYXeContract = await ethers.getContractAt(
      "ReversibleICOToken",
      LYXE_ADDRESS,
    );

    const LockBoxFactory = await ethers.getContractFactory("ERC777LockBox");

    lockbox = await LockBoxFactory.connect(lockboxContractDeployer).deploy(
      ETH_HOLDER_WITHOUT_LYXE,
    );

    await lockbox.waitForDeployment();
  });

  describe("tokensReceived function", () => {
    it("should register the sender when tokens are received", async function () {
      const LYXeHolder = LYXeHolders[0];
      const LYXeHolderSigner = await ethers.getImpersonatedSigner(LYXeHolder);

      await LYXeContract.connect(LYXeHolderSigner).send(
        lockbox.target,
        10,
        "0x",
      );

      const isRegistered = await lockbox.isRegistered(LYXeHolder);
      expect(isRegistered).to.be.true;
    });

    it("should not register blacklisted addresses", async function () {
      const LYXeHolder = LYXeHolders[1];
      const LYXeHolderSigner = await ethers.getImpersonatedSigner(LYXeHolder);

      await lockbox
        .connect(lockboxContractDeployer)
        .blacklistAddress(LYXeHolder);

      await expect(
        LYXeContract.connect(LYXeHolderSigner).send(lockbox.target, 10, "0x"),
      ).to.be.revertedWith("ERC777LockBox: sender is blacklisted");

      const isRegistered = await lockbox.isRegistered(LYXeHolder);
      expect(isRegistered).to.be.false;
    });
  });
});
