mod utils;
use utils::merkle_proof;

use dep::std::hash::poseidon::bn254::hash_1;
use dep::std::hash::poseidon::bn254::hash_2;
use dep::std::hash::poseidon::bn254::hash_3;

global DEPTH = 16;

struct Output {
    root: Field,
    y: Field,
    nullifier: Field,
}

fn main(
    identitySecret: Field, 
    userMessageLimit: Field,
    messageId: Field,
    pathSelectors: [Field; DEPTH],
    pathElements: [Field; DEPTH],
    x: pub Field, 
    externalNullifier: pub Field
) -> pub Output {
    let identityCommitment = hash_1([identitySecret]);
    let rateCommitment = hash_2([identityCommitment, userMessageLimit]);

    let root = merkle_proof(rateCommitment, pathSelectors, pathElements);

    assert(messageId as u16 < userMessageLimit as u16);

    let a1 = hash_3([identitySecret, externalNullifier, messageId]);
    let y = identitySecret + a1 * x;

    let nullifier = hash_1([a1]);

    Output {
        root,
        y,
        nullifier
    }
}
