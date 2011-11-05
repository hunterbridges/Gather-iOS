typedef enum {
    kGatherAppStateLoggedOutNeedsPhoneNumber,
    kGatherAppStateLoggedOutHasPhoneNumber,
    kGatherAppStateLoggedOutNeedsVerification,
    kGatherAppStateLoggedOutHasVerification,
    kGatherAppStateLoggedOutFinalizing,
    kGatherAppStateLoggedIn
} GatherAppState;