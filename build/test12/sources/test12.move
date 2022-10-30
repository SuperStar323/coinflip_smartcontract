module coinflip::test12 {
    use std::signer;
    use aptos_framework::account;
    use aptos_framework::timestamp;
    use aptos_std::table::{Self, Table};
    use aptos_std::guid::{Self, ID};

// ----------------------------
    struct OfferStore has key {
        offers: Table<ID, Offer>
    }

    struct Offer has drop, store {
        id: ID,
        seller:address,
        amount:u64,
        flag:bool,
        result:bool,
    }

    public fun create_listing_id(owner: &signer): ID {
        let gid = account::create_guid(owner);
        guid::id(&gid)
    }

    public entry fun set_message<CoinType>(account: signer, message: bool) acquires OfferStore {

        let sec = timestamp::now_seconds();
        let rest = sec % 2;
        
        let _result : bool = false;
        if (rest == 0){
            if (message == true) {
                _result = true;
            }
        } else {
            if (message == false) {
                _result = true;
            }
        };
        let account_addr = signer::address_of(&account);
        let id = create_listing_id(&account);

        if(!exists<OfferStore>(account_addr)){
            move_to(&account, OfferStore{
                offers: table::new()
            })
        };

        let offer_store = borrow_global_mut<OfferStore>(account_addr);
        table::add(&mut offer_store.offers, id, Offer {
            id, seller : account_addr, amount : 1000, flag: message , result:_result
        });
    }

}
