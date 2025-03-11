;; Supplier Performance Contract
;; Tracks adherence to quality standards over time

(define-map supplier-performances
  { supplier-id: uint }
  {
    total-tests: uint,
    passed-tests: uint,
    last-test-date: uint
  }
)

(define-read-only (get-supplier-performance (supplier-id uint))
  (map-get? supplier-performances { supplier-id: supplier-id })
)

(define-public (update-supplier-performance (supplier-id uint) (test-passed bool))
  (let
    (
      (current-performance (default-to
        { total-tests: u0, passed-tests: u0, last-test-date: u0 }
        (get-supplier-performance supplier-id)
      ))
    )
    (ok (map-set supplier-performances
      { supplier-id: supplier-id }
      {
        total-tests: (+ (get total-tests current-performance) u1),
        passed-tests: (+ (get passed-tests current-performance) (if test-passed u1 u0)),
        last-test-date: block-height
      }
    ))
  )
)

(define-read-only (get-supplier-quality-score (supplier-id uint))
  (match (get-supplier-performance supplier-id)
    performance (let
      (
        (total (get total-tests performance))
        (passed (get passed-tests performance))
      )
      (if (> total u0)
        (/ (* passed u100) total)
        u0
      )
    )
    u0
  )
)

