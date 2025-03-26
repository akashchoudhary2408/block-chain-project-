module MyModule::Staking {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a staking record.
    struct StakingRecord has store {
        staked_amount: u64,    // Amount of tokens staked
        rewards_earned: u64,   // Total rewards earned by the user
    }

    /// Function to stake tokens in the contract.
    public fun stake(owner: &signer, amount: u64) acquires StakingRecord {
        let record = borrow_global_mut<StakingRecord>(signer::address_of(owner));

        // Withdraw the tokens from the staker's account
        coin::withdraw<AptosCoin>(owner, amount);

        // Update the staked amount
        record.staked_amount = record.staked_amount + amount;
    }

    /// Function to claim rewards based on the staked amount.
    public fun claim_rewards(owner: &signer) acquires StakingRecord {
        let record = borrow_global_mut<StakingRecord>(signer::address_of(owner));

        // Calculate rewards (here we assume 10% reward per staking)
        let rewards = record.staked_amount * 10 / 100;
        record.rewards_earned = record.rewards_earned + rewards;

        // Deposit the rewards to the user's account
        coin::deposit<AptosCoin>(owner, rewards);
    }
}
