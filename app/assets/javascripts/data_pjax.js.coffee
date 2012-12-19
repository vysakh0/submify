$('[data-pjax-container]').bind("start.pjax", ->
            $('[data-pjax-container]').hide 0
        ).bind "end.pjax", ->
            $('[data-pjax-container]').fadeIn 500
