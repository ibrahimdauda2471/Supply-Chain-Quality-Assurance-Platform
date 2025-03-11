;; Product Specification Contract
;; Defines quality standards for each product

(define-map product-specifications
  { product-id: uint }
  {
    name: (string-ascii 64),
    category: (string-ascii 32),
    quality-standards: (list 10 (string-ascii 64)),
    created-at: uint,
    updated-at: uint
  }
)

(define-data-var last-product-id uint u0)

(define-read-only (get-product-specification (product-id uint))
  (map-get? product-specifications { product-id: product-id })
)

(define-public (add-product-specification (name (string-ascii 64)) (category (string-ascii 32)) (quality-standards (list 10 (string-ascii 64))))
  (let
    (
      (new-product-id (+ (var-get last-product-id) u1))
    )
    (var-set last-product-id new-product-id)
    (ok (map-set product-specifications
      { product-id: new-product-id }
      {
        name: name,
        category: category,
        quality-standards: quality-standards,
        created-at: block-height,
        updated-at: block-height
      }
    ))
  )
)

(define-public (update-product-specification (product-id uint) (name (string-ascii 64)) (category (string-ascii 32)) (quality-standards (list 10 (string-ascii 64))))
  (match (map-get? product-specifications { product-id: product-id })
    existing-spec (ok (map-set product-specifications
      { product-id: product-id }
      (merge existing-spec {
        name: name,
        category: category,
        quality-standards: quality-standards,
        updated-at: block-height
      })
    ))
    (err u404) ;; Product specification not found
  )
)

