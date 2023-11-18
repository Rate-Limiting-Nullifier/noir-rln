mod utils;
use utils::merkle_proof;
use utils::DEPTH;

use dep::std::hash::poseidon::bn254::hash_1;
use dep::std::hash::poseidon::bn254::hash_2;
use dep::std::hash::poseidon::bn254::hash_3;

struct Output {
    root: Field,
    y: Field,
    nullifier: Field,
}

fn main(
    identitySecret: Field, 
    userMessageLimit: u16,
    messageId: u16,
    pathSelectors: [u1; DEPTH],
    pathElements: [Field; DEPTH],
    x: pub Field, 
    externalNullifier: pub Field
) -> pub Output {
    let identityCommitment = hash_1([identitySecret]);
    let rateCommitment = hash_2([identityCommitment, userMessageLimit as Field]);

    let root = merkle_proof(rateCommitment, pathSelectors, pathElements);

    assert(messageId < userMessageLimit, "messageId exceeds limit");

    let a1 = hash_3([identitySecret, externalNullifier, messageId as Field]);
    let y = identitySecret + a1 * x;

    let nullifier = hash_1([a1]);

    Output {
        root,
        y,
        nullifier
    }
}
