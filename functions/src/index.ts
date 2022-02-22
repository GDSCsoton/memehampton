/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
// eslint-disable-next-line @typescript-eslint/no-var-requires
const cors = require("cors")({origin: true});
import fetch from "node-fetch";

admin.initializeApp();


