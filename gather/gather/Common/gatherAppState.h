//
//  appState.h
//  gather
//
//  Created by Hunter B on 7/11/11.
//  Copyright 2011 Meedeor, LLC. All rights reserved.
//

typedef enum {
    kGatherAppStateLoggedOutNeedsPhoneNumber,
    kGatherAppStateLoggedOutHasPhoneNumber,
    kGatherAppStateLoggedOutNeedsVerification,
    kGatherAppStateLoggedOutHasVerification,
    kGatherAppStateLoggedOutFinalizing,
    kGatherAppStateLoggedIn
} gatherAppState;