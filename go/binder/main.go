package main

import (
	"fmt"
	"net/http"

	"github.com/bytedance/go-tagexpr/v2/binding"
)

type query struct {
	a struct {
		a string
		b string
		c string
		d string
	} `query:"a"`
}

func main() {
	err := http.ListenAndServe(":12346", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		binder := binding.New(nil)

		queryParameters := &query{}

		if err := binder.BindAndValidate(queryParameters, r, nil); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		w.WriteHeader(http.StatusOK)
		w.Write([]byte(fmt.Sprintf("%v", *queryParameters)))
	}))

	if err != nil {
		panic(err)
	}
}
