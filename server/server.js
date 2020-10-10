var express=require('express');
var app=express();
//var mysql=require('mysql');
var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded());
//const Web3=require('web3');
//const rpcURL="http://localhost:8000";
//const web3=new Web3(rpcURL);
var admin = require("firebase-admin");
var serviceAccount = require("C:/Users/User/SweetTrust/sweettrust.json");
const R = 6371e3; // earth's mean radius in metres
const sin = Math.sin, cos=Math.cos, acos = Math.acos;
const π = Math.PI;
var geofirestore=require('geofirestore');
admin.initializeApp({
  credential: admin.credential.cert({
    "type": "service_account",
    "project_id": "sweet-trust-43bcd",
    "private_key_id": "7117e5a68d2bd2619f3da6fc8127a17d5381642f",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCyGALfxY7SXxHZ\nYT8VbfDzSUPgX+DmiTFjjDSfK5sDAk7RaWor3fLDiKaSucIj0z6MJL/MjBu56jAL\nzU+4Y0OC1wpNzIyX/NJDlRILHlzW2x8TnLSuGdpiptkyKnFayEAcwWaytRbzBe1b\nlwcaB5umeSoBgOkIdhhQXZ4RxgYrOo39bzK4mFJFYJBKCrcxrhmPxKERz7QsaYWM\nxRkOGzpVPaldhGvq1iIlFhei0938lZZYTnuj4hP98NjqK6aqZNbA33MS+4u97A5+\n93dRa/41gBPs0q/JiA61C8YCcY9yF01Ob6LnjTn7Vvi/bLiukEuGAPnqCSetaR1s\nyn+NbakpAgMBAAECggEAAJybComA1zQS723zM0D9dlB5JnvPDv9bac3a/JJdlK0G\n2oNe/eBGfO50u7as8Sh78nqYwoZNcyfX5PHeU/cByO+xd/HKbWE5XQ7B/XR6vp71\nrizpbr1bTVX8iYt2AiQq80lptHjndmRRjQ64U6Poqk85ZA9kkTf9FylFn5yyts2t\noTzIPenAKwdO2m7uNKQtAyf1Kak88jlEGzqfMwd4wcqqtco++UqTIEpHO03a+G5D\nxBElLQmRch72yibt/m8E19uG6sqqIpHjuZ2Wh5Wv/pyX7VxfAyx3cQ+Cmj4hN1hc\nnuI1JyLvpl+n3in2fPfMnJbAspx26JsvSr5YnWexyQKBgQD0V+lvqOT1jzJ0yH2m\nzjGxNiw54nwo5/wu1OwaCU5F36JhbG/SmGCDhpT/llBzFT0ySHC4bL+2/Dp6gze6\nuQZ7bbPaNqagpx/0zH99z9fN+N51QXPkPOaQHY7xSGUyeyNlTKd0iJtGF95CWlwk\nGEKk42sEaYSGK3pHu1xVL8hmrQKBgQC6lwOTpUtCod52mc8rYYV2L/2ZyUQ+rm0N\nBlxWD6DNwfkClAL6goQw282GC11b+ERallTN5gdDxfsjtGHurcdGsJFerSH1ic0I\ni8ESMmJpXmJ2Fqu+YHqnrMFm6yom45NTzhqK4S8US9VWgcZQm+zEgRrygfO0Gnkp\n1u6RK9Nn7QKBgHQ+2s0Hkh4NSVjsBXN1R4jil/nV+XHQpFZ3b/gXE0kE0xD8cNrF\nKa2JOpu6HH4TzbB9bDshabgZmYytnrbTzfSsxVL8ixuFRxvEqqblWeshClzIjeU4\n4AwSM+4wngx9LuLDrCsxzoVzV4dDy/BUJmih1UkdFjJqvtsflRbmC7ZlAoGBAJ38\n7g9e3wmtS1M6yrqdmUbIPb+wNjOotzdXEmngU7TEsBYpwxff2RQRmMUN7F/KJ/5X\n2bh5M9+DzDCgNGfHBrtpF72FdQKVSmEZDEJfHQrA2zfH3GWXBWPiF+QP7KH/Aajt\nE3ZSUu2phBr6STPJwsFj27BIrlPqMntlvJx48kjFAoGBAOlJuIQ4dR3tJRPFsbvV\nc6dBxWo90V7Seh44ywxmf/98y/9T7Vw2G7+KvphWOvlaUK7gZr1KwjHmwOtVyQ1b\nMLwgLpZ7TsyeEy/rOVr+n0pVvcQNN5xArELfbtqR/mRSnJsNJVEvpWr3pg/30A+D\nLZhUe3vRRktx75O3GsdfrE13\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-xmvnr@sweet-trust-43bcd.iam.gserviceaccount.com",
    "client_id": "110439623395366885317",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xmvnr%40sweet-trust-43bcd.iam.gserviceaccount.com"
  }
  ),
  databaseURL: "https://sweet-trust-43bcd.firebaseio.com"
});

const db=admin.firestore();
            
const path = require('path');
const fs = require('fs');


// Create a GeoFirestore reference
const GeoFirestore = geofirestore.initializeApp(db);

// Create a GeoCollection reference
var geocollection = GeoFirestore.collection('locationInfo');

// Add a GeoDocument to a GeoCollection

var bytecode = "0x"+"60806040523480156100115760006000fd5b505b33600060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550600060016000508190909055505b610067565b611b47806100766000396000f3fe60806040523480156100115760006000fd5b50600436106100a35760003560e01c80634bee8c3b116100675780634bee8c3b146101515780638d0a5fbb1461016d57806397114f431461018b57806397c45fd6146101a7578063e885b5b3146101c3576100a3565b806305cf8d5d146100a9578063146468ba146100c7578063235c6f4e146100e3578063383dfcdf146100ff57806345fa8aae1461011b576100a3565b60006000fd5b6100b16101f9565b6040516100be9190611873565b60405180910390f35b6100e160048036038101906100dc919061177f565b61020b565b005b6100fd60048036038101906100f89190611663565b61025d565b005b6101196004803603810190610114919061158b565b6105bd565b005b61013560048036038101906101309190611560565b6106c3565b604051610148979695949392919061188f565b60405180910390f35b61016b60048036038101906101669190611560565b610bf5565b005b610175610c05565b6040516101829190611873565b60405180910390f35b6101a560048036038101906101a09190611560565b610c17565b005b6101c160048036038101906101bc91906115ca565b610c90565b005b6101dd60048036038101906101d89190611560565b610ddb565b6040516101f09796959493929190611906565b60405180910390f35b60006002600050549050610208565b90565b81600360005060008581526020019081526020016000206000506009016000508190909055508060036000506000858152602001908152602001600020600050600a016000508190909055505b505050565b600160016000505401600160005081909090555061027961132a565b60405180604001604052808381526020016040518060200160405280600081526020015081526020015090506102ad611347565b60405180606001604052808981526020018881526020018781526020015090506102d561136b565b60405180604001604052808681526020018781526020015090506102f7611388565b6040518061014001604052808d8152602001600073ffffffffffffffffffffffffffffffffffffffff1681526020013373ffffffffffffffffffffffffffffffffffffffff1681526020018c815260200184815260200183815260200160008152602001600081526020018581526020016000600581111561037557fe5b815260200150905080600360005060008e815260200190815260200160002060005060008201518160000160005090905560208201518160010160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555060408201518160020160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506060820151816003016000509080519060200190610453929190611427565b50608082015181600401600050600082015181600001600050909055602082015181600101600050909055604082015181600201600050909055505060a08201518160070160005060008201518160000160005090805190602001906104ba929190611427565b5060208201518160010160005090805190602001906104da929190611427565b50505060c08201518160090160005090905560e082015181600a0160005090905561010082015181600b016000506000820151816000016000509080519060200190610527929190611427565b506020820151816001016000509080519060200190610547929190611427565b50505061012082015181600d0160006101000a81548160ff0219169083600581111561056f57fe5b02179055509050507fffa896d8919f0556f53ace1395617969a3b53ab5271a085e28ac0c4a3724e63d8c6040516105a69190611873565b60405180910390a1505050505b5050505050505050565b81600560058111156105cb57fe5b60036000506000838152602001908152602001600020600050600d0160009054906101000a900460ff16600581111561060057fe5b14151561060d5760006000fd5b6005600581111561061a57fe5b60036000506000858152602001908152602001600020600050600d0160009054906101000a900460ff16600581111561064f57fe5b14151561065c5760006000fd5b7f9c10979f47dcbf51acc02c232259d46dcc86504d27461ddf194d85d48e771b2c828460036000506000878152602001908152602001600020600050600401600050600201600050546040516106b49392919061183b565b60405180910390a15b5b505050565b60006000600060606000600060006106d9611388565b600360005060008a815260200190815260200160002060005060405180610140016040529081600082016000505481526020016001820160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020016002820160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001600382016000508054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156108535780601f1061082857610100808354040283529160200191610853565b820191906000526020600020905b81548152906001019060200180831161083657829003601f168201915b50505050508152602001600482016000506040518060600160405290816000820160005054815260200160018201600050548152602001600282016000505481526020015050815260200160078201600050604051806040016040529081600082016000508054600181600116156101000203166002900480601f01602080910402602001604051908101604052809291908181526020018280546001816001161561010002031660029004801561094c5780601f106109215761010080835404028352916020019161094c565b820191906000526020600020905b81548152906001019060200180831161092f57829003601f168201915b50505050508152602001600182016000508054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156109f15780601f106109c6576101008083540402835291602001916109f1565b820191906000526020600020905b8154815290600101906020018083116109d457829003601f168201915b505050505081526020015050815260200160098201600050548152602001600a8201600050548152602001600b8201600050604051806040016040529081600082016000508054600181600116156101000203166002900480601f016020809104026020016040519081016040528092919081815260200182805460018160011615610100020316600290048015610aca5780601f10610a9f57610100808354040283529160200191610aca565b820191906000526020600020905b815481529060010190602001808311610aad57829003601f168201915b50505050508152602001600182016000508054600181600116156101000203166002900480601f016020809104026020016040519081016040528092919081815260200182805460018160011615610100020316600290048015610b6f5780601f10610b4457610100808354040283529160200191610b6f565b820191906000526020600020905b815481529060010190602001808311610b5257829003601f168201915b5050505050815260200150508152602001600d820160009054906101000a900460ff166005811115610b9d57fe5b6005811115610ba857fe5b81526020015050905080600001518160400151826020015183606001518460c001518560e00151866101200151975097509750975097509750975050610bea56505b919395979092949650565b8060026000508190909055505b50565b60006001600050549050610c14565b90565b600560036000506000838152602001908152602001600020600050600d0160006101000a81548160ff02191690836005811115610c5057fe5b02179055507fe12bffbbe83ae1297213ac026cbb97fdc03fe813c8439df296a956dd48f7ccc781604051610c849190611873565b60405180910390a15b50565b826003600050600086815260200190815260200160002060005060010160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555081600360005060008681526020019081526020016000206000506007016000506000016000509080519060200190610d24929190611427565b50600260036000506000868152602001908152602001600020600050600d0160006101000a81548160ff02191690836005811115610d5e57fe5b02179055508060036000506000868152602001908152602001600020600050600b016000506001016000509080519060200190610d9c929190611427565b507fc01bfb839aad58a8fb00585a84eb0bc81dfdafe39ffea47928c2f9e0a6cd30a084604051610dcc9190611873565b60405180910390a15b50505050565b6000600060006060606060606060610df1611388565b600360005060008a815260200190815260200160002060005060405180610140016040529081600082016000505481526020016001820160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020016002820160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001600382016000508054600181600116156101000203166002900480601f016020809104026020016040519081016040528092919081815260200182805460018160011615610100020316600290048015610f6b5780601f10610f4057610100808354040283529160200191610f6b565b820191906000526020600020905b815481529060010190602001808311610f4e57829003601f168201915b50505050508152602001600482016000506040518060600160405290816000820160005054815260200160018201600050548152602001600282016000505481526020015050815260200160078201600050604051806040016040529081600082016000508054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156110645780601f1061103957610100808354040283529160200191611064565b820191906000526020600020905b81548152906001019060200180831161104757829003601f168201915b50505050508152602001600182016000508054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156111095780601f106110de57610100808354040283529160200191611109565b820191906000526020600020905b8154815290600101906020018083116110ec57829003601f168201915b505050505081526020015050815260200160098201600050548152602001600a8201600050548152602001600b8201600050604051806040016040529081600082016000508054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156111e25780601f106111b7576101008083540402835291602001916111e2565b820191906000526020600020905b8154815290600101906020018083116111c557829003601f168201915b50505050508152602001600182016000508054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156112875780601f1061125c57610100808354040283529160200191611287565b820191906000526020600020905b81548152906001019060200180831161126a57829003601f168201915b5050505050815260200150508152602001600d820160009054906101000a900460ff1660058111156112b557fe5b60058111156112c057fe5b81526020015050905080608001516020015181608001516000015182608001516040015183610100015160000151846101000151602001518560a00151600001518660a001516020015197509750975097509750975097505061131f56505b919395979092949650565b604051806040016040528060608152602001606081526020015090565b60405180606001604052806000815260200160008152602001600081526020015090565b604051806040016040528060608152602001606081526020015090565b60405180610140016040528060008152602001600073ffffffffffffffffffffffffffffffffffffffff168152602001600073ffffffffffffffffffffffffffffffffffffffff168152602001606081526020016113e4611347565b81526020016113f161136b565b8152602001600081526020016000815260200161140c61132a565b81526020016000600581111561141e57fe5b81526020015090565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061146857805160ff191683800117855561149b565b8280016001018555821561149b579182015b8281111561149a578251826000509090559160200191906001019061147a565b5b5090506114a891906114ac565b5090565b6114d491906114b6565b808211156114d057600081815060009055506001016114b6565b5090565b9056611b10565b6000813590506114ea81611ada565b5b92915050565b600082601f83011215156115055760006000fd5b8135611518611513826119c1565b611992565b915080825260208301602083018583830111156115355760006000fd5b611540838284611a73565b5050505b92915050565b60008135905061155981611af5565b5b92915050565b6000602082840312156115735760006000fd5b60006115818482850161154a565b9150505b92915050565b60006000604083850312156115a05760006000fd5b60006115ae8582860161154a565b92505060206115bf858286016114db565b9150505b9250929050565b6000600060006000608085870312156115e35760006000fd5b60006115f18782880161154a565b9450506020611602878288016114db565b935050604085013567ffffffffffffffff8111156116205760006000fd5b61162c878288016114f1565b925050606085013567ffffffffffffffff81111561164a5760006000fd5b611656878288016114f1565b9150505b92959194509250565b60006000600060006000600060006000610100898b0312156116855760006000fd5b60006116938b828c0161154a565b985050602089013567ffffffffffffffff8111156116b15760006000fd5b6116bd8b828c016114f1565b97505060406116ce8b828c0161154a565b96505060606116df8b828c0161154a565b95505060806116f08b828c0161154a565b94505060a089013567ffffffffffffffff81111561170e5760006000fd5b61171a8b828c016114f1565b93505060c089013567ffffffffffffffff8111156117385760006000fd5b6117448b828c016114f1565b92505060e089013567ffffffffffffffff8111156117625760006000fd5b61176e8b828c016114f1565b9150505b9295985092959890939650565b600060006000606084860312156117965760006000fd5b60006117a48682870161154a565b93505060206117b58682870161154a565b92505060406117c68682870161154a565b9150505b9250925092565b6117da81611a0d565b82525b5050565b6117ea81611a60565b82525b5050565b60006117fc826119ef565b61180681856119fb565b9350611816818560208601611a83565b61181f81611ab8565b84019150505b92915050565b61183481611a55565b82525b5050565b600060608201905061185060008301866117d1565b61185d602083018561182b565b61186a604083018461182b565b5b949350505050565b6000602082019050611888600083018461182b565b5b92915050565b600060e0820190506118a4600083018a61182b565b6118b160208301896117d1565b6118be60408301886117d1565b81810360608301526118d081876117f1565b90506118df608083018661182b565b6118ec60a083018561182b565b6118f960c08301846117e1565b5b98975050505050505050565b600060e08201905061191b600083018a61182b565b611928602083018961182b565b611935604083018861182b565b818103606083015261194781876117f1565b9050818103608083015261195b81866117f1565b905081810360a083015261196f81856117f1565b905081810360c083015261198381846117f1565b90505b98975050505050505050565b6000604051905081810181811067ffffffffffffffff821117156119b65760006000fd5b80604052505b919050565b600067ffffffffffffffff8211156119d95760006000fd5b601f19601f83011690506020810190505b919050565b6000815190505b919050565b60008282526020820190505b92915050565b6000611a1882611a34565b90505b919050565b6000819050611a2e82611aca565b5b919050565b600073ffffffffffffffffffffffffffffffffffffffff821690505b919050565b60008190505b919050565b6000611a6b82611a20565b90505b919050565b828183376000838301525b505050565b60005b83811015611aa25780820151818401525b602081019050611a86565b83811115611ab1576000848401525b505b505050565b6000601f19601f83011690505b919050565b600681101515611ad657fe5b5b50565b611ae381611a0d565b81141515611af15760006000fd5b5b50565b611afe81611a55565b81141515611b0c5760006000fd5b5b50565bfea264697066735822122084b55834f72c8a3f374d5221181ca499c683cfcbc993805c3965924097cd97ba64736f6c63430006060033";
var abi = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"deliveryPerson","type":"address"},{"indexed":false,"internalType":"uint256","name":"_orderId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"deliveryCharge","type":"uint256"}],"name":"OnDeliveryMoneyReceived","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"orderId","type":"uint256"}],"name":"OrderPlaced","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"orderId","type":"uint256"}],"name":"PickOrder","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"orderId","type":"uint256"}],"name":"ReceiveOrder","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"orderId","type":"uint256"}],"name":"ReceivedOrderedFood","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"orderId","type":"uint256"}],"name":"RouteOrder","type":"event"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"}],"name":"customerReceivedOrder","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getOrderCount","outputs":[{"internalType":"uint256","name":"count","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"}],"name":"getOrderStatus","outputs":[{"internalType":"uint256","name":"orderid","type":"uint256"},{"internalType":"address","name":"consumerId","type":"address"},{"internalType":"address","name":"deliveryPersonId","type":"address"},{"internalType":"string","name":"orderNotes","type":"string"},{"internalType":"uint256","name":"foodRating","type":"uint256"},{"internalType":"uint256","name":"carrierRating","type":"uint256"},{"internalType":"enum SupplyChain.State","name":"orderState","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getRating","outputs":[{"internalType":"uint256","name":"rating","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"}],"name":"getRemainingStatus","outputs":[{"internalType":"uint256","name":"quantity","type":"uint256"},{"internalType":"uint256","name":"orderPrice","type":"uint256"},{"internalType":"uint256","name":"deliveryCharge","type":"uint256"},{"internalType":"string","name":"consumerNumber","type":"string"},{"internalType":"string","name":"carrierNumber","type":"string"},{"internalType":"string","name":"pickupCoordinates","type":"string"},{"internalType":"string","name":"deliveryCoordinates","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"},{"internalType":"address","name":"_carrier","type":"address"}],"name":"orderDeliveredToCustomer","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"},{"internalType":"address","name":"deliveryPerson","type":"address"},{"internalType":"string","name":"pickupCoordinates","type":"string"},{"internalType":"string","name":"_phn","type":"string"}],"name":"orderPicked","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"},{"internalType":"string","name":"orderNotes","type":"string"},{"internalType":"uint256","name":"quantity","type":"uint256"},{"internalType":"uint256","name":"orderPrice","type":"uint256"},{"internalType":"uint256","name":"deliveryCharge","type":"uint256"},{"internalType":"string","name":"location","type":"string"},{"internalType":"string","name":"pickupCoordinates","type":"string"},{"internalType":"string","name":"_phn","type":"string"}],"name":"placeOrder","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"},{"internalType":"uint256","name":"_foodRating","type":"uint256"},{"internalType":"uint256","name":"_carrierRating","type":"uint256"}],"name":"rate","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"setRating","outputs":[],"stateMutability":"nonpayable","type":"function"}]              
         
  

app.   post('/signUp',function(req,res){
    console.log(req.body);
    var name=req.body.user;
    var pass=req.body.password;
    var phn=req.body.phn;
    var type=req.body.type;
    if(type=="customer"){
    db.collection('logininfo').doc(phn).get().then(function(doc){
        if(!doc.exists){
            
            // web3.eth.personal.newAccount(pass).then(function(e){
             
            //     web3.eth.getAccounts().then(accounts=>{
                    
            //     web3.eth.personal.unlockAccount(accounts[0],"hackforme",0).then(async function(kj){

            //         web3.eth.personal.unlockAccount(e,pass,0).then(async function(f){
            //             await web3.eth.sendTransaction({from:accounts[0],to:e,value:99999999999999999});
            //             let deploy_contract=await new web3.eth.Contract(abi);
            //             let account=e;
            //             let payload={data:bytecode};
            //             let parameter={
            //                 from:e
            //             };
            //             deploy_contract.deploy(payload).send(parameter,(err, transactionHash)=>console.log(transactionHash)).on('confirmation',()=>{}).then(async function(newContractInstance){
            //                 console.log(newContractInstance.options.address);
                             const dataToSubmit={
                                name:name,
                                password:pass,
                                //account:"e",
                                phn:phn,
                                account:"1278341293847812374",
                                contractAcc:"13123123123132123"
                                //contractAcc:newContractInstance.options.address
                            };
                            db.collection('logininfo').doc(phn).set(dataToSubmit);
                            db.collection('orderInfo').doc(phn).set({});
                           
            //             })

                       

            //         });
            //        // console.log(e);
            //     })
            //     })
            // });
            res.send(200);
        }
        else{
            console.log("account already exists");
            res.send("account already exists");
        }
    })


    

}

else if(type=="carrier"){
        db.collection('carrierInfo').doc(phn).get().then(function(doc){
        if(!doc.exists){
            
            // web3.eth.personal.newAccount(pass).then(function(e){
             
            //     web3.eth.getAccounts().then(accounts=>{
                    
            //     web3.eth.personal.unlockAccount(accounts[0],"hackforme",0).then(async function(kj){

            //         web3.eth.personal.unlockAccount(e,pass,0).then(async function(f){
            //             await web3.eth.sendTransaction({from:accounts[0],to:e,value:99999999999999999});
            //             let deploy_contract=await new web3.eth.Contract(abi);
            //             let account=e;
            //             let payload={data:bytecode};
            //             let parameter={
            //                 from:e
            //             };
            //             deploy_contract.deploy(payload).send(parameter,(err, transactionHash)=>console.log(transactionHash)).on('confirmation',()=>{}).then(async function(newContractInstance){
            //                 console.log(newContractInstance.options.address);
                             const dataToSubmit={
                                name:name,
                                password:pass,
                                //account:"e",
                                phn:phn,
                                account:"1278341293847812374",
                                contractAcc:"13123123123132123",
                                coordinates: new admin.firestore.GeoPoint(0, 0)
                                //contractAcc:newContractInstance.options.address
                            };
                            db.collection('carrierInfo').doc(phn).set(dataToSubmit);
                            db.collection('orderInfo').doc(phn).set({});
                           
            //             })

                       

            //         });
            //        // console.log(e);
            //     })
            //     })
            // });
            res.send(200);
        }
        else{
            console.log("account already exists");
            res.send("account already exists");
        }
    })
}
})

app.post('/lastLocation', async function(req,res){
    var phn=req.body.phn;
    var longitude=parseFloat(req.body.longitude);
    var latitude=parseFloat(req.body.latitude);

    await db.collection('carrierInfo').doc(phn).get().then(async function(doc){
        if(doc.exists){

            GeoFirestore.collection('carrierInfo').doc(phn).update({
               
                // The coordinates field must be a GeoPoint!
                coordinates: new admin.firestore.GeoPoint(parseFloat(latitude), parseFloat(longitude))
              })
        }
        else{
            GeoFirestore.collection('carrierInfo').doc(phn).set({
               
                // The coordinates field must be a GeoPoint!
                coordinates: new admin.firestore.GeoPoint(parseFloat(latitude), parseFloat(longitude))
              })
        }
    })

    // const query = GeoFirestore.collection('locationInfo').near({ center: new admin.firestore.GeoPoint(latitude, longitude), radius: 1000 });

    //     // Get query (as Promise)
    //     query.get().then((value) => {
    //     // All GeoDocument returned by GeoQuery, like the GeoDocument added above
    //     console.log(value.docs);
    //     });

})


app.post('/pickOrder', function(req,res){
    var phn=req.body.phn;
    var orderId=req.body.orderId;
    GeoFirestore.collection('ongoinOrders').doc(orderId.toString()).set({carrierPhn:phn,orderStatus:"orderPicked"});
        
})


app.post('/signIn',function(req,res){
    var phn=req.body.phn;
    var pass=req.body.password;
    db.collection('logininfo').doc(phn).get().then(async function(doc){
        var file=doc.data();
        if(file.password==pass){
            console.log("match");
            //await web3.eth.personal.unlockAccount(file.account,pass);
            const orders = [];
            await db.collection('orderInfo').doc(phn).collection('orders').get()
                .then(async function(querySnapshot) {
                querySnapshot.docs.forEach(doc => {
                orders.push(doc.data());
                });
            });
            res.send(orders);
        }
        else{
            console.log("Mismatch");
            res.send(404);
        }
    })
})
app.post("/getNearbyOrders",async function(req,res){
    latPickup=req.body.longitude;
    longPickup=req.body.latitude;
    
    let orders=[];
    let locations= GeoFirestore.collection('ongoinOrders').near({center:new admin.firestore.GeoPoint(parseFloat(latPickup),parseFloat(longPickup)),
    radius:10000}).where("orderStatus","==","orderPlaced");
       locations.get().then(async function(querySnapshot) {
        querySnapshot.docs.forEach(doc => {
        orders.push(doc.data());
        });
        
        res.send(orders);
        });
})

app.post("/placeOrder", async function(req,res){
    var phn=req.body.phn;
    var _orderId;
    await db.collection('orderInfo').doc('lastOrderId').get().then(async function(id){
        _orderId=parseInt(id.data().orderId)+1;

        await db.collection('orderInfo').doc('lastOrderId').update({orderId:_orderId});
    })

    var notes=req.body.notes;
    var quantity=req.body.quantity;
    var price = req.body.price;
    var deliveryCharge=req.body.deliveryCharge;
    var location=req.body.location;
    var pickupCoordinates=req.body.pickupCoordinates;
    var expectedTime=req.body.expectedTime;
    let latLocation,longLocation,latPickup,longPickup;
    location=location.split(',');
    pickupCoordinates=pickupCoordinates.split(',');
    latLocation=location[0];
    longLocation=location[1];
    latPickup=pickupCoordinates[0];
    longPickup=pickupCoordinates[1];
    db.collection('logininfo').doc(phn).get().then(async function(doc){
        if(doc.exists){
            var file=doc.data();
        const dataToSubmit={
            orderId:_orderId,
            notes:notes,
            quantity:quantity,
            price:price,
            deliveryCharge:deliveryCharge,
            location:new admin.firestore.GeoPoint(parseFloat(latLocation),parseFloat(longLocation)),
            coordinates:new admin.firestore.GeoPoint(parseFloat(latPickup),parseFloat(longPickup)),
            orderStatus:"orderPlaced",
            phn:phn,
            carrierPhn:"",
            expectedTime:expectedTime
        };
        let availableCarriers=[];
        GeoFirestore.collection('orderInfo').doc(phn).collection('orders').doc(_orderId.toString()).set(dataToSubmit);
        GeoFirestore.collection('ongoinOrders').doc(_orderId.toString()).set(dataToSubmit);
        let locations= GeoFirestore.collection('carrierInfo').near({center:new admin.firestore.GeoPoint(parseFloat(latPickup),parseFloat(longPickup)),
        radius:10000});
           locations.get().then(async function(querySnapshot) {
            querySnapshot.docs.forEach(doc => {
                availableCarriers.push(doc.data());
            });
            
            res.send(availableCarriers);
            });
       // db.collection("posts").doc(postId).collection("likes").doc().set(dataToSubmit)
    //     let acccountNumber=file.account;
    //     let contractAcc=file.contractAcc;
    //     let contractInstance=new web3.eth.Contract(abi,contractAcc);
    //     web3.eth.personal.unlockAccount(acccountNumber,file.password,0).then(async function(){
    //         await contractInstance.methods.setRating(4).send({from:acccountNumber});
    //         var rating=await contractInstance.methods.getRating().call({from:acccountNumber});

    //    await contractInstance.methods.placeOrder(_orderId,notes,quantity,price,deliveryCharge,location,pickupCoordinates,phn).send({from:acccountNumber,gas:400000});
       
    //    let results=await contractInstance.methods.getOrderStatus(_orderId).call({from:acccountNumber});
    //    let results2=await contractInstance.methods.getRemainingStatus(_orderId).call({from:acccountNumber});
    //     console.log(results+results2);
     //   })
    }
    })
})


app.get('/',function(req,res){
    var firstAccount;

web3.eth.getAccounts().then(e => { 
 
 res.send(e);
}) 

});



app.get('/createAccount',function(req,res){



});

var server=app.listen(3000, '192.168.10.94');