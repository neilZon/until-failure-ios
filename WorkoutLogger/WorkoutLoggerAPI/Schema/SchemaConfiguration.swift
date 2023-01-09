// @generated
// This file was automatically generated and can be edited to
// provide custom configuration for a generated GraphQL schema.
//
// Any changes to this file will not be overwritten by future
// code generation execution.

import ApolloAPI

enum SchemaConfiguration: ApolloAPI.SchemaConfiguration {
    static func cacheKeyInfo(for type: Object, object: JSONObject) -> CacheKeyInfo? {
        // Implement this function to configure cache key resolution for your schema types.
        guard let id = object["id"] as? String else {
            return nil
        }

        return CacheKeyInfo(id: id)
    }
}
