use dep::std::hash::poseidon::bn254::hash_2;

fn merkle_proof<N>(leaf: Field, pathSelectors: [Field; N], pathElements: [Field; N]) -> Field {
    let mut levelHashes = [0; N];
    levelHashes[0] = leaf;

    let mut muxes = [[0; 2]; N];
    for i in 0..N {
        assert(pathSelectors[i] * (pathSelectors[i] - 1) == 0);

        muxes[i] = mux(
            [
                [levelHashes[i], pathElements[i]],
                [pathElements[i], levelHashes[i]]
            ],
            pathSelectors[i]
        );

        levelHashes[i + 1] = hash_2([muxes[i][0], muxes[i][1]]);
    }

    levelHashes[N]
}

fn mux(c: [[Field; 2]; 2], s: Field) -> [Field; 2] {
    let mut out: [Field; 2] = [0; 2];
    for i in 0..2 {
        out[i] = (c[i][1] - c[i][0]) * s + c[i][0];
    }
    out
}