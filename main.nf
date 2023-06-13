extflow.enable.dsl=2

fch =  Channel.empty()



process firstProcess {
    debug true
    container '703608045793.dkr.ecr.us-east-1.amazonaws.com/python_with_aws:v1'
    executor 'awsbatch'
    queue 'maestro3-small-machines'
    errorStrategy = 'finish'

    output:
    file(f1)

    script:
    f1 = "f1.txt"
    """
    echo hi > $f1
    """

}

process printProcess {
    debug true
    container '703608045793.dkr.ecr.us-east-1.amazonaws.com/python_with_aws:v1'
    executor 'awsbatch'
    queue 'maestro3-small-machines'
    errorStrategy = 'finish'


    input:
    file(f1)

    script:
    """
    cat $f1
    """

}

process appendProcess {
    debug true

    input:
    file(f1)

    output:
    file(f1)

    script:
    """
    echo hi2 >> $f1
    """

}


workflow WF1{
    main:
        firstProcess()
        printProcess(firstProcess)
    emit:
        fch = firstProcess.out

}

workflow WF2{
    take:
       fch 
    
    main:
        printProcess(appendProcess(fch))

}

workflow{
    WF1()
}
