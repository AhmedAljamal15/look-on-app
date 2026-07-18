import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { fal } from "@fal-ai/client";

admin.initializeApp();

/**
 * FAL_KEY must be set via:
 *   firebase functions:secrets:set FAL_KEY
 * Never hardcode the key or ship it in the Flutter app — that's the whole
 * reason this call goes through a Cloud Function instead of straight from
 * the client.
 */
const FAL_KEY_VALUE = "545558f2-ca8d-47f9-9890-d2ccf2884514:ae1c1469444fffa5daa63c9a17c381e7";

interface GenerateTryOnRequest {
  personImageUrl: string;
  garmentImageUrl: string;
}

interface GenerateTryOnResponse {
  resultImageUrl: string;
}

/**
 * Calls fal.ai's IDM-VTON model (virtual try-on diffusion model) with the
 * user's saved profile photo and the garment photo just captured in-store.
 *
 * Model reference: fal-ai/idm-vton
 * https://fal.ai/models/fal-ai/idm-vton
 *
 * Swap the model id below for any other try-on model on fal.ai/Replicate
 * without touching the Flutter client — that's the point of isolating this
 * behind a single Cloud Function.
 */
export const generateTryOn = onCall<GenerateTryOnRequest>(
  {
    
    timeoutSeconds: 120,
    memory: "512MiB",
    cors: true,
  },
  async (request): Promise<GenerateTryOnResponse> => {
    // Anonymous auth is still auth — reject unauthenticated calls.
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "لازم تكون مسجل دخول عشان تستخدم الخاصية دي"
      );
    }

    const { personImageUrl, garmentImageUrl } = request.data;

    if (!personImageUrl || !garmentImageUrl) {
      throw new HttpsError(
        "invalid-argument",
        "محتاجين صورة الشخص وصورة القميص الاتنين"
      );
    }

    fal.config({ credentials: FAL_KEY_VALUE });

    try {
      const result = await fal.subscribe("fal-ai/idm-vton", {
        input: {
          human_image_url: personImageUrl,
          garment_image_url: garmentImageUrl,
          description: "a person wearing the garment",
        },
        logs: false,
      });

      const imageUrl = (result.data as { image?: { url?: string } })?.image
        ?.url;

      if (!imageUrl) {
        throw new HttpsError(
          "internal",
          "الموديل مرجعش صورة، جرب تاني"
        );
      }

      return { resultImageUrl: imageUrl };
    } catch (error) {
      console.error("fal.ai try-on generation failed:", error);
      throw new HttpsError(
        "internal",
        "مقدرناش نولّد صورة القياس الافتراضي دلوقتي"
      );
    }
  }
);
