export default ({ env }: { env: (key: string, defaultValue?: any) => any }) => ({
  "cloudinary-media-library": {
    enabled: true,
    config: {
      cloudName: env("CLOUDINARY_NAME"),
      apiKey: env("CLOUDINARY_KEY"),
      encryptionKey: env("CLOUDINARY_SECRET"),
    },
  },
  upload: {
    config: {
      provider: "@strapi/provider-upload-cloudinary",
      providerOptions: {
        cloud_name: env("CLOUDINARY_NAME"),
        api_key: env("CLOUDINARY_KEY"),
        api_secret: env("CLOUDINARY_SECRET"),
      },
    },
  },
});
